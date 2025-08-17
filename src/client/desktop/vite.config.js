import { defineConfig } from 'vite'
import { sveltekit } from '@sveltejs/kit/vite'

export default defineConfig({
  plugins: [sveltekit()],
  server: {
    port: 3000,
    host: true,
    proxy: {
      '/api/rust/': {
        target: 'http://localhost:8001',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api\/rust\//, '')
      },
      '/api/java/': {
        target: 'http://localhost:8002',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api\/java\//, '')
      },
      '/api/python/': {
        target: 'http://localhost:8003',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api\/python\//, '')
      },
      '/api/java-agent/': {
        target: 'http://localhost:8004',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api\/java-agent\//, '')
      },
      '/api/orchestration/': {
        target: 'http://localhost:8005',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api\/orchestration\//, '')
      }
    }
  },
  build: {
    target: 'esnext'
  }
})
