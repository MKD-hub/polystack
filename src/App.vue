<script setup lang="ts">
  import { onMounted, ref } from "vue";
  import { initCanvas, clear } from "@/scripts/webgl";
  import { loadPrefs } from "@/scripts/prefs";
  import { initShaderProgram, setupUniforms } from "@/gl";
  import TopBar from "@/layouts/TopBar.vue";
  import Footer from "@/layouts/Footer.vue";
  import { wasmStore } from "@/scripts/wasm-store";
  import { loadWasm } from "@/scripts/loader";

  import vsSource from "@/gl/example.vertex.glsl?raw";
  import fsSource from "@/gl/example.frag.glsl?raw";
  const size = 100.0;
  const aspect = 1.77;
  const spacing = 5.0;
  const vertical_limit = Math.floor(size / 1.77);

  const total =
    Math.floor((2 * size) / spacing) +
    Math.floor((2 * vertical_limit) / spacing) +
    2;

  const canvas = ref<HTMLCanvasElement | null>(null);

  // @ts-expect-error: prefs is used in the template code below
  const prefs = loadPrefs();

  onMounted(async () => {
    void (await loadWasm());
    // Load editor config
    void wasmStore.exports.getEditorConfig(
      prefs.fov,
      prefs.aspect,
      prefs.canvasWidth,
      prefs.canvasHeight
    );

    const grid_ptr = wasmStore.exports.getGridPtr();

    const gridLinesView = new Float32Array(
      wasmStore.memory.buffer,
      grid_ptr,
      128 * 3 // Total number of floats to read
    );
    console.log(gridLinesView);

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

  <!-- Canvas area -->
  <div class="relative">
    <canvas
      ref="canvas"
      class="absolute border border-dashed border-white inset-0"
      title="3D Renderer"
      :width="prefs.canvasWidth"
      :height="prefs.canvasHeight"
    />
  </div>
</template>
