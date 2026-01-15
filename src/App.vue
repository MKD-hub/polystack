<script setup lang="ts">
import { onMounted, ref } from "vue";
import { initCanvas, clear, loadShaderSource } from "@/scripts/webgl";
import { loadPrefs } from "@/scripts/prefs";
import { initShaderProgram, setupUniforms } from "@/gl";
import TopBar from "@/layouts/TopBar.vue";
import Footer from "@/layouts/Footer.vue";

import vsSource from "@/gl/example.vertex.glsl?raw";
import fsSource from "@/gl/example.frag.glsl?raw";

const canvas = ref<HTMLCanvasElement | null>(null);

// @ts-expect-error: prefs is used in the template code below
const prefs = loadPrefs();

onMounted(async () => {
  const gl = initCanvas(canvas.value);

  clear(gl);

  const shaderProgram = initShaderProgram(gl, vsSource, fsSource);
  gl.useProgram(shaderProgram);

  const programUniformLoc = setupUniforms(gl, shaderProgram, prefs);

  console.log(programUniformLoc);
});

</script>

<template>
  <TopBar />
  <div class="flex relative flex-col w-full">
    <!-- Canvas area -->
    <canvas
      ref="canvas"
      class="absolute inset-0"
      title="3D Renderer"
      :width="prefs.canvasWidth"
      :height="prefs.canvasHeight"
    />
  </div>

  <Footer />
</template>
