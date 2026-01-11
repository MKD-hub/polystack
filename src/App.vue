<script setup lang="ts">
import { onMounted, ref } from "vue";
import { initCanvas, clear, loadShaderSource } from "@/scripts/webgl";
import { loadPrefs } from "@/scripts/prefs";
import { initShaderProgram } from "../public/gl";
import TopBar from "@/layouts/TopBar.vue";
import Footer from "@/layouts/Footer.vue";

const canvas = ref<HTMLCanvasElement | null>(null);
const prefs = loadPrefs();

onMounted(async () => {
  const vsSource = await loadShaderSource("./gl/example.vertex.glsl");
  const fsSource = await loadShaderSource("./gl/example.frag.glsl");

  console.log("[SOURCES]", vsSource, fsSource);

  const gl = initCanvas(canvas.value);

  clear(gl);

  const shaderProgram = initShaderProgram(gl, vsSource, fsSource);

  const programInfo = {
    program: shaderProgram,
    attribLocations: {
      vertexPosition: gl.getAttribLocation(shaderProgram, "aVertexPosition"),
    },
    uniformLocations: {
      projectionMatrix: gl.getUniformLocation(
        shaderProgram,
        "uProjectionMatrix"
      ),
      modelViewMatrix: gl.getUniformLocation(shaderProgram, "uModelViewMatrix"),
    },
  };

  console.log("[PROGRAM INFO]", programInfo);
});
</script>

<template>
  <TopBar />
  <div class="flex relative flex-col w-full">
    <!-- Canvas area -->
    <canvas
      ref="canvas"
      class="absolute inset-0"
      :width="prefs.canvasWidth"
      :height="prefs.canvasHeight"
    />
  </div>

  <Footer />
</template>
