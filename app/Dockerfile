FROM python:3.12-slim
WORKDIR /app
COPY server.py .
RUN useradd -r -u 1001 appuser
USER 1001
EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')"
CMD ["python", "server.py"]
