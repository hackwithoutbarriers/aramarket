import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react-swc";
import path from "path";

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
      "@radix-ui/react-slot@1.1.2": "@radix-ui/react-slot",
      "@radix-ui/react-label@2.1.2": "@radix-ui/react-label",
      "@radix-ui/react-radio-group@1.2.3": "@radix-ui/react-radio-group",
      "@radix-ui/react-separator@1.1.2": "@radix-ui/react-separator",
      "lucide-react@0.487.0": "lucide-react",
      "class-variance-authority@0.7.1": "class-variance-authority",
    },
  },
  pool: "forks",
  poolOptions: {
    forks: {
      singleFork: true,
    },
  },
  fileParallelism: false,
  maxWorkers: 1,
  minWorkers: 1,
  test: {
    environment: "jsdom",
    setupFiles: "./src/test/setup.ts",
    globals: true,
    testTimeout: 20000,
    hookTimeout: 20000,
  },
});
