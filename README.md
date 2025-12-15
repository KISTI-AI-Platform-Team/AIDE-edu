# AIDE-edu

AIDE-edu는 **교육·연구용 LLM 실험 플랫폼**입니다.  
웹 브라우저에서 다음과 같은 작업을 손쉽게 수행할 수 있습니다.

- 채팅 / 프롬프트 실험
- JSON/JSONL 형식 데이터셋 업로드
- SFT 기반 모델 학습 (Full Fine-Tuning / LoRA)
- 학습된 모델 평가 (Evaluation)
- CPU / GPU 환경 모두 지원 (Docker 기반)

---

## 데모 / 자료

- 예제 학습 데이터셋: `dataset/qa_100.jsonl`  
- 예제 평가 데이터셋: `evaluation_dataset/benchmark_30.csv`  
- 실행 파일(Windows): `run-aide.bat`  
- 실행 파일(Linux / macOS): `run-aide.sh`  

---

## 실행 방법

### 1. 사전 준비

- Docker 설치 (Docker Desktop 또는 Docker Engine)

### 2. 이미지 다운로드

CPU 전용 이미지
`docker pull kistiofficial/aide-edu-cpu:latest`

GPU 전용 이미지
`docker pull kistiofficial/aide-edu-gpu:latest`


### 3. 실행

- **Windows**  
  레포지토리를 클론(또는 압축 해제)한 후 `run-aide.bat` 실행

- **Linux / macOS**  
  레포지토리를 클론(또는 압축 해제)한 후 아래 명령 실행:

      chmod +x run-aide.sh
      ./run-aide.sh

스크립트 실행 후 터미널에 표시되는 주소(예: `http://localhost:8081`)로 브라우저에서 접속하면  
웹 UI를 통해 채팅, 데이터셋 업로드, 학습 및 평가 기능을 사용할 수 있습니다.

---

## AIDE-edu 소개영상
[![AIDE-edu 소개 영상](https://img.youtube.com/vi/bRqW8BVVV3U/0.jpg)](https://www.youtube.com/watch?v=bRqW8BVVV3U)

---

## 기타

- 기본 테스트용 데이터셋과 평가셋은 작은 크기로 제공되며,  
  동일한 형식으로 사용자 정의 데이터셋을 추가해 활용할 수 있습니다.
- 이 레포지토리는 교육 및 연구 목적으로 제공됩니다.

