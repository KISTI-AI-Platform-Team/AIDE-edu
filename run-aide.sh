#!/usr/bin/env bash

# AIDE-edu Docker 자동 실행 스크립트 (Linux / macOS)

###############################################
# 호스트 포트 변경
HOST_PORT=8000
CONTAINER_PORT=8000  # 컨테이너 내부 포트(변경X)
###############################################

echo "=========================================="
echo "AIDE-edu Docker 자동 실행 스크립트"
echo "=========================================="
echo

# 1. GPU 감지
echo "[1/3] GPU 환경 검사 중..."
GPU_AVAILABLE=false

if command -v nvidia-smi >/dev/null 2>&1; then
    if nvidia-smi >/dev/null 2>&1; then
        GPU_AVAILABLE=true
        echo "√ NVIDIA GPU 감지됨"
        nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null || true
    else
        echo "× GPU를 찾을 수 없습니다. CPU 버전으로 실행합니다."
    fi
else
    echo "× GPU를 찾을 수 없습니다. CPU 버전으로 실행합니다."
fi

echo

# 2. Docker 이미지 / 컨테이너 이름 / 실행 명령 설정
if [ "$GPU_AVAILABLE" = true ]; then
    IMAGE="kistiofficial/aide-edu-gpu:latest"
    CONTAINER_NAME="aide-edu-gpu"
    DOCKER_ARGS=(
        run -d --gpus all
        --name "$CONTAINER_NAME"
        -e "HOST_BASE_DIR=$PWD"
        -e "DEVICE=gpu"
        -e "TEXTEXTRACT_LANG=eng+kor"
        -e "HF_HOME=/tmp/huggingface_cache"
        -e "PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:256"
        -p "${HOST_PORT}:${CONTAINER_PORT}"
        -v "$PWD/dataset:/dataset"
        -v "$PWD/models:/models"
        -v "$PWD/outs:/outs"
        -v "$PWD/raw_dataset:/raw_dataset"
        -v "$PWD/evaluation_dataset:/evaluation_dataset"
        -v "$PWD/logs:/app/logs"
        "$IMAGE"
    )
else
    IMAGE="kistiofficial/aide-edu-cpu:latest"
    CONTAINER_NAME="aide-edu-cpu"
    DOCKER_ARGS=(
        run -d
        --name "$CONTAINER_NAME"
        -e "HOST_BASE_DIR=$PWD"
        -e "DEVICE=cpu"
        -e "TEXTEXTRACT_LANG=eng+kor"
        -e "HF_HOME=/tmp/huggingface_cache"
        -p "${HOST_PORT}:${CONTAINER_PORT}"
        -v "$PWD/dataset:/dataset"
        -v "$PWD/models:/models"
        -v "$PWD/outs:/outs"
        -v "$PWD/raw_dataset:/raw_dataset"
        -v "$PWD/evaluation_dataset:/evaluation_dataset"
        -v "$PWD/logs:/app/logs"
        "$IMAGE"
    )
fi

# 3. 기존 컨테이너 정리 (해당 타입만)
echo "[2/3] 기존 컨테이너 확인 중..."
if docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1; then
    echo "√ 기존 컨테이너 제거 완료: $CONTAINER_NAME"
else
    echo "√ 기존 컨테이너 없음: $CONTAINER_NAME"
fi
echo

# 4. Docker 컨테이너 실행
echo "[3/3] Docker 컨테이너 실행 중..."
echo "이미지: $IMAGE"
echo "컨테이너 이름: $CONTAINER_NAME"
echo

echo -n "명령어: docker "
printf '%q ' "${DOCKER_ARGS[@]}"
echo
echo

if CONTAINER_ID=$(docker "${DOCKER_ARGS[@]}"); then
    echo "=========================================="
    echo "√ AIDE-edu 실행 성공!"
    echo "=========================================="
    echo
    echo "컨테이너 ID: $CONTAINER_ID"
    echo "컨테이너 이름: $CONTAINER_NAME"
    echo "포트: http://localhost:${HOST_PORT}"
    echo "작업 디렉토리: $PWD"
    echo
    echo "상태 확인: docker ps"
    echo "로그 확인: docker logs $CONTAINER_NAME"
    echo "종료하기: docker stop $CONTAINER_NAME"
    echo
else
    echo "=========================================="
    echo "× 실행 실패"
    echo "=========================================="
    echo
    echo "Docker가 설치되어 있고 실행 중인지 확인하세요."
    echo "GPU 버전 사용 시 NVIDIA Docker 설정을 확인하세요."
    echo
    exit 1
fi

