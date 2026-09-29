@echo off
REM RECALL-X Full Stack Startup (Docker Compose) - Windows
REM Requires: Docker Desktop, Docker Compose v2+
REM Hindsight repo should be cloned as sibling: ..\hindsight-ai

echo =========================================
echo   RECALL-X Full Stack Startup
echo =========================================
echo.

set HINDSIGHT_PATH=..\hindsight-ai

if not exist %HINDSIGHT_PATH% (
    echo Hindsight repo not found at %HINDSIGHT_PATH%
    echo Cloning Hindsight...
    git clone https://github.com/hindsight-ai/hindsight-ai %HINDSIGHT_PATH%
)

if not exist backend\.env (
    echo Creating backend\.env from example...
    copy backend\.env.example backend\.env
    echo ⚠️  Edit backend\.env with your API keys before continuing!
    echo    Required: LLM_API_KEY (OpenAI or compatible)
    pause
    exit /b 1
)

if not exist frontend\.env.local (
    echo Creating frontend\.env.local from example...
    copy frontend\.env.example frontend\.env.local
)

if not exist %HINDSIGHT_PATH%\.env (
    echo Creating Hindsight .env from example...
    copy %HINDSIGHT_PATH%\.env.example %HINDSIGHT_PATH%\.env
    echo ⚠️  Edit %HINDSIGHT_PATH%\.env with your LLM_API_KEY!
    pause
    exit /b 1
)

echo.
echo Starting full stack with Docker Compose...
echo Services:
echo   - Hindsight DB (PostgreSQL)     : localhost:5432
echo   - Hindsight API                 : localhost:8000
echo   - Hindsight Dashboard           : localhost:3001
echo   - RECALL-X Backend              : localhost:8001
echo   - RECALL-X Frontend             : localhost:3000
echo.

docker compose -f docker-compose.full.yml up --build -d

echo.
echo Waiting for services to be healthy...
timeout /t 10 >nul

echo.
echo Checking service health...
docker compose -f docker-compose.full.yml ps

echo.
echo =========================================
echo   RECALL-X is running!
echo =========================================
echo.
echo   Frontend:      http://localhost:3000
echo   Backend API:   http://localhost:8001
echo   API Docs:      http://localhost:8001/docs
echo   Hindsight API: http://localhost:8000
echo   Hindsight UI:  http://localhost:3001
echo.
echo To seed demo data:
echo   docker compose -f docker-compose.full.yml exec backend python seed/demo_experiments.py
echo.
echo To view logs:
echo   docker compose -f docker-compose.full.yml logs -f
echo.
echo To stop:
echo   docker compose -f docker-compose.full.yml down
echo.
pause