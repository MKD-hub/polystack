<script setup lang="ts">
  import { onMounted, onUnmounted, ref } from "vue";
  import { initCanvas, clear } from "@/scripts/webgl";
  import { loadPrefs } from "@/scripts/prefs";
  import { initShaderProgram, setupUniforms } from "@/gl";
  import TopBar from "@/layouts/TopBar.vue";
  import Footer from "@/layouts/Footer.vue";
  import { wasmStore } from "@/scripts/wasm-store";
  import { loadWasm } from "@/scripts/loader";
  import { Reader } from "@/utils/utils";
  import { drawGrid } from "@/core/draw-grid";
  import MouseController from "@/controllers/mouse.controller.ts";

  import vsSource from "@/gl/grid.vertex.glsl?raw";
  import fsSource from "@/gl/grid.frag.glsl?raw";
  const size = 100.0;
  const aspect = 1.77;
  const spacing = 5.0;
  const vertical_limit = Math.floor(size / 1.77);

  let g_view_mat: number;
  let g_perspective_mat: number;

  const total =
    Math.floor((2 * size) / spacing) +
    Math.floor((2 * vertical_limit) / spacing) +
    2;

  const canvas = ref<HTMLCanvasElement | null>(null);
  let animationId: number;

  // @ts-expect-error: prefs is used in the template code below
  const prefs = loadPrefs();

  onMounted(async () => {
    void (await loadWasm());

    const mc = new MouseController(canvas.value!);

    // Load editor config
    void wasmStore.exports.getEditorConfig(
      prefs.fov,
      prefs.aspect,
      prefs.near,
      prefs.far,
      prefs.sensitivity,
      prefs.canvasWidth,
      prefs.canvasHeight
    );

    const grid_ptr = wasmStore.exports.getGridPtr();

    const grid_lines_view = Reader(
      grid_ptr,
      total * 6,
      Float32Array,
      wasmStore.exports
    );

    void wasmStore.exports.initCamera();

    const gl = initCanvas(canvas.value);
    const shaderProgram = initShaderProgram(gl, vsSource, fsSource);
    gl.useProgram(shaderProgram);
    const grid_buffer = gl.createBuffer();

    const programUniformLoc = setupUniforms(gl, shaderProgram, prefs);

    const render = () => {
      void clear(gl);
      void wasmStore.exports.updateCamera();
      g_view_mat = wasmStore.exports.returnViewMatrix();
      g_perspective_mat = wasmStore.exports.returnPerspectiveMatrix();

      const viewMat = Reader(g_view_mat, 16, Float32Array, wasmStore.exports);
      const projMat = Reader(
        g_perspective_mat,
        16,
        Float32Array,
        wasmStore.exports
      );

      drawGrid(
        gl,
        shaderProgram,
        grid_lines_view,
        grid_buffer,
        total * 2,
        viewMat,
        projMat
      );
      animationId = requestAnimationFrame(render);
    };

    render();
  });

  onUnmounted(async () => {
    // clean-up
    cancelAnimationFrame(animationId);
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
