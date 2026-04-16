import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';

export default defineConfig({
  plugins: [svelte()],
  base: './',
  build: {
    outDir: '../ui/standalone',
    emptyOutDir: true,
    minify: 'esbuild',
    assetsInlineLimit: 8192,
  },
  server: {
    port: 3000,
  },
});
