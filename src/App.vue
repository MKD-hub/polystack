<script setup lang="ts">
import { onMounted, ref } from "vue";
import { initCanvas, clear } from "@/scripts/webgl";
import { loadPrefs } from "@/scripts/prefs";

const canvas = ref<HTMLCanvasElement | null>(null);
const prefs = loadPrefs();

onMounted(() => {
  const gl = initCanvas(canvas.value);

  clear(gl);
});
</script>

<template>
  <div class="flex relative flex-col w-full">
    <!-- Canvas area -->
    <canvas
      ref="canvas"
      class="absolute inset-0"
      :width="prefs.canvasWidth"
      :height="prefs.canvasHeight"
    ></canvas>
  </div>
</template>
