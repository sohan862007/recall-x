#!/bin/bash
# RECALL-X Full Stack Startup (Docker Compose)
# Requires: Docker, Docker Compose v2+
# Hindsight repo should be cloned as sibling: ../hindsight-ai

set -e

echo "========================================="
echo "  RECALL-X Full Stack Startup"
echo "========================================="
echo ""

# Check for Hindsight repo
HINDSIGHT_PATH="../hindsight-ai"
if [ ! -d "$HINDSIGHT_PATH" ]; then
    echo "Hindsight repo not found at $HINDSIGHT_PATH"
    echo "Cloning Hindsight..."
    git clone https://github.com/hindsight-ai/hindsight-ai "$HINDSIGHT_PATH"
fi

# Check for .env files
if [ ! -f ./backend/.env ]; then
    echo "Creating backend/.env from example..."
    cp ./backend/.env.example ./backend/.env
    echo "⚠️  Edit backend/.env with your API keys before continuing!"
    echo "   Required: LLM_API_KEY (OpenAI or compatible)"
    exit 1
fi

if [ ! -f ./frontend/.env.local ]; then
    echo "Creating frontend/.env.local from example..."
    cp ./frontend/.env.example ./frontend/.env.local
fi

if [ ! -f "$HINDSIGHT_PATH/.env" ]; then
    echo "Creating Hindsight .env from example..."
    cp "$HINDSIGHT_PATH/.env.example" "$HINDSIGHT_PATH/.env"
    echo "⚠️  Edit $HINDSIGHT_PATH/.env with your LLM_API_KEY!"
    exit 1
fi

echo ""
echo "Starting full stack with Docker Compose..."
echo "Services:"
echo "  - Hindsight DB (PostgreSQL)     : localhost:5432"
echo "  - Hindsight API                 : localhost:8000"
echo "  - Hindsight Dashboard           : localhost:3001"
echo "  - RECALL-X Backend              : localhost:8001"
echo "  - RECALL-X Frontend             : localhost:3000"
echo ""

docker compose -f docker-compose.full.yml up --build -d

echo ""
echo "Waiting for services to be healthy..."
sleep 10

# Check health
echo ""
echo "Checking service health..."
docker compose -f docker-compose.full.yml ps

echo ""
echo "========================================="
echo "  RECALL-X is running!"
echo "========================================="
echo ""
echo "  Frontend:      http://localhost:3000"
echo "  Backend API:   http://localhost:8001"
echo "  API Docs:      http://localhost:8001/docs"
echo "  Hindsight API: http://localhost:8000"
echo "  Hindsight UI:  http://localhost:3001"
echo ""
echo "To seed demo data:"
echo "  docker compose -f docker-compose.full.yml exec backend python seed/demo_experiments.py"
echo ""
echo "To view logs:"
echo "  docker compose -f docker-compose.full.yml logs -f"
echo ""
echo "To stop:"
echo "  docker compose -f docker-compose.full.yml down"