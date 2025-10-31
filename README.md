# 🚀 CI/CD First Demo — GitHub Actions + Docker + Python

This project demonstrates how to set up **Continuous Integration (CI)** and **Continuous Deployment (CD)** using **GitHub Actions**, **Python**, and **Docker**.

It’s designed for **beginners** to understand how automated pipelines work — from running tests to building and pushing Docker images.

---

## 🧠 What This YAML Does (In Simple Terms)

This file automates two big things whenever you **push code** or **make a pull request** to your `main` branch:

1. ✅ **CI (Continuous Integration)** → checks your code (like running tests).  
2. 🐳 **CD (Continuous Deployment/Delivery)** → builds a Docker image and uploads it to Docker Hub.

---

## 🧩 The Complete YAML File (With Explanation)

Below is the full workflow file (`.github/workflows/ci-cd.yml`) with **detailed explanations** for every line 👇

---

```yaml
# 🧠 1️⃣ Workflow name — This is what you'll see in the GitHub Actions dashboard
name: ci cd first demo

# 🧠 2️⃣ Trigger (when the workflow runs)
# It runs automatically when you push code or create a pull request to the "main" branch
on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

# 🧠 3️⃣ Permissions — allows the workflow to read repository contents
permissions:
  contents: read

# 🧠 4️⃣ Jobs — this workflow contains two jobs: one for CI and one for CD
jobs:

  # ================================================================
  # 🧱 CI JOB — Continuous Integration
  # ================================================================
  ci-for-demo:
    # 🧠 Runs on a fresh Ubuntu Linux virtual machine
    runs-on: ubuntu-latest
  
    steps:
      # 🧩 Step 1: Checkout code from repository
      # This downloads your repository code into the GitHub Actions runner
      - name: Checkout code from repository
        uses: actions/checkout@v4
  
      # 🧩 Step 2: Set up Python environment
      # Installs Python 3.10 so we can run and test Python apps
      - name: Set up Python 3.10
        uses: actions/setup-python@v3
        with:
          python-version: "3.10"

      # 🧩 Step 3: Install dependencies
      # Installs all required Python packages listed in requirements.txt
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      # 🧩 Step 4: Run tests or demo command
      # Runs pytest to test your application and ensure it works correctly
      - name: Run the demo
        run: pytest

  
  # ================================================================
  # 🧱 CD JOB — Continuous Deployment
  # ================================================================
  cd-for-demo:
    # 🧠 This ensures the CD job runs only after the CI job succeeds
    needs: ci-for-demo
    runs-on: ubuntu-latest

    steps:
      # 🧩 Step 1: Checkout code again (new machine, fresh environment)
      - name: checkout code
        uses: actions/checkout@v3
     
      # 🧩 Step 2: Set up Docker Buildx
      # Enables advanced Docker build features (multi-platform, caching, etc.)
      - name: set up docker build x
        uses: docker/setup-buildx-action@v2

      # 🧩 Step 3: Login to Docker Hub
      # Uses your Docker credentials securely stored as GitHub Secrets
      - name: Login to docker hub
        uses: docker/login-action@v2
        with:
            username: ${{ secrets.DOCKER_USER }}
            password: ${{ secrets.DOCKER_PASSWORD }}
      
      # 🧩 Step 4: Build and push Docker image
      # Builds a Docker image and uploads it to Docker Hub
      - name: build and push docker image      
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ${{ secrets.DOCKER_USER }}/app:latest

      # 🧩 Step 5: Print image digest (for tracking/debugging)
      - name: Image digest
        run: echo ${{ steps.build-and-publish.outputs.digest }}
