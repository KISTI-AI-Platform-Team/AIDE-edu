@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem ==========================================
rem AIDE-edu Docker 자동 실행 스크립트 (Windows)
rem ==========================================

rem ------------------------------------------
rem 여기만 수정해서 호스트 포트 변경
rem ------------------------------------------
set HOST_PORT=8000
set CONTAINER_PORT=8000

echo ==========================================
echo AIDE-edu Docker 자동 실행 스크립트 (Windows)
echo ==========================================
echo.

rem 1. GPU 감지
echo [1/3] GPU 환경 검사 중...

set GPU_AVAILABLE=0

where nvidia-smi >NUL 2>&1
if %ERRORLEVEL%==0 (
    nvidia-smi >NUL 2>&1
    if %ERRORLEVEL%==0 (
        set GPU_AVAILABLE=1
        echo √ NVIDIA GPU 감지됨
        nvidia-smi --query-gpu=name --format=csv,noheader 2>NUL
    ) else (
        echo × GPU를 찾을 수 없습니다. CPU 버전으로 실행합니다.
    )
) else (
    echo × GPU를 찾을 수 없습니다. CPU 버전으로 실행합니다.
)

echo.

rem 2. 이미지 / 컨테이너 이름 설정
if %GPU_AVAILABLE%==1 (
    set IMAGE=kistiofficial/aide-edu-gpu:latest
    set CONTAINER_NAME=aide-edu-gpu
) else (
    set IMAGE=kistiofficial/aide-edu-cpu:latest
    set CONTAINER_NAME=aide-edu-cpu
)

rem 3. 기존 컨테이너 정리
echo [2/3] 기존 컨테이너 확인 중...
docker rm -f %CONTAINER_NAME% >NUL 2>&1
if %ERRORLEVEL%==0 (
    echo √ 기존 컨테이너 제거 완료: %CONTAINER_NAME%
) else (
    echo √ 기존 컨테이너 없음: %CONTAINER_NAME%
)
echo.

rem 4. Docker 컨테이너 실행
echo [3/3] Docker 컨테이너 실행 중...
echo 이미지: %IMAGE%
echo 컨테이너 이름: %CONTAINER_NAME%
echo.

echo 실행 명령:
if %GPU_AVAILABLE%==1 (
    echo docker run -d --gpus all ^
      --name %CONTAINER_NAME% ^
      -e HOST_BASE_DIR="%CD%" ^
      -e DEVICE=gpu ^
      -e TEXTEXTRACT_LANG=eng+kor ^
      -e HF_HOME=/tmp/huggingface_cache ^
      -e PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:256 ^
      -p %HOST_PORT%:%CONTAINER_PORT% ^
      -v "%CD%/dataset:/dataset" ^
      -v "%CD%/models:/models" ^
      -v "%CD%/outs:/outs" ^
      -v "%CD%/raw_dataset:/raw_dataset" ^
      -v "%CD%/evaluation_dataset:/evaluation_dataset" ^
      -v "%CD%/logs:/app/logs" ^
      %IMAGE%
    echo.

    docker run -d --gpus all ^
      --name %CONTAINER_NAME% ^
      -e HOST_BASE_DIR="%CD%" ^
      -e DEVICE=gpu ^
      -e TEXTEXTRACT_LANG=eng+kor ^
      -e HF_HOME=/tmp/huggingface_cache ^
      -e PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:256 ^
      -p %HOST_PORT%:%CONTAINER_PORT% ^
      -v "%CD%/dataset:/dataset" ^
      -v "%CD%/models:/models" ^
      -v "%CD%/outs:/outs" ^
      -v "%CD%/raw_dataset:/raw_dataset" ^
      -v "%CD%/evaluation_dataset:/evaluation_dataset" ^
      -v "%CD%/logs:/app/logs" ^
      %IMAGE%
) else (
    echo docker run -d ^
      --name %CONTAINER_NAME% ^
      -e HOST_BASE_DIR="%CD%" ^
      -e DEVICE=cpu ^
      -e TEXTEXTRACT_LANG=eng+kor ^
      -e HF_HOME=/tmp/huggingface_cache ^
      -p %HOST_PORT%:%CONTAINER_PORT% ^
      -v "%CD%/dataset:/dataset" ^
      -v "%CD%/models:/models" ^
      -v "%CD%/outs:/outs" ^
      -v "%CD%/raw_dataset:/raw_dataset" ^
      -v "%CD%/evaluation_dataset:/evaluation_dataset" ^
      -v "%CD%/logs:/app/logs" ^
      %IMAGE%
    echo.

    docker run -d ^
      --name %CONTAINER_NAME% ^
      -e HOST_BASE_DIR="%CD%" ^
      -e DEVICE=cpu ^
      -e TEXTEXTRACT_LANG=eng+kor ^
      -e HF_HOME=/tmp/huggingface_cache ^
      -p %HOST_PORT%:%CONTAINER_PORT% ^
      -v "%CD%/dataset:/dataset" ^
      -v "%CD%/models:/models" ^
      -v "%CD%/outs:/outs" ^
      -v "%CD%/raw_dataset:/raw_dataset" ^
      -v "%CD%/evaluation_dataset:/evaluation_dataset" ^
      -v "%CD%/logs:/app/logs" ^
      %IMAGE%
)

if %ERRORLEVEL%==0 (
    echo ==========================================
    echo √ AIDE-edu 실행 성공!
    echo ==========================================
    echo.
    echo 컨테이너 이름: %CONTAINER_NAME%
    echo 포트: http://localhost:%HOST_PORT%
    echo 포트 매핑: %HOST_PORT%:%CONTAINER_PORT%
    echo 작업 디렉터리: %CD%
    echo.
    echo 상태 확인: docker ps
    echo 로그 확인: docker logs %CONTAINER_NAME%
    echo 종료하기: docker stop %CONTAINER_NAME%
    echo.
) else (
    echo ==========================================
    echo × 실행 실패
    echo ==========================================
    echo.
    echo Docker Desktop가 설치되어 있고 실행 중인지 확인하세요.
    echo GPU 사용 시 NVIDIA 드라이버 및 nvidia-smi 사용 가능 여부를 확인하세요.
    echo.
    exit /b 1
)

ENDLOCAL

