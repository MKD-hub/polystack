<script setup lang="ts">
  const VEC3_WIDTH = 3; // 3 elements per Vec3

  import { onMounted, onUnmounted, ref } from "vue";
  import { initCanvas, clear } from "@/scripts/webgl";
  import { loadPrefs } from "@/scripts/prefs";
  import { initShaderProgram, setupUniforms } from "@/gl";
  import TopBar from "@/layouts/TopBar.vue";
  import Footer from "@/layouts/Footer.vue";
  import Tools from "@/components/tools.vue";
  import { wasmStore } from "@/scripts/wasm-store";
  import { loadWasm } from "@/scripts/loader";
  import { Reader } from "@/utils/utils";
  import { drawGridQuad } from "@/core/draw-grid-quad";
  import MouseController from "@/controllers/mouse.controller.ts";

  import vsSource from "@/gl/grid.vertex.glsl?raw";
  import fsSource from "@/gl/grid.frag.glsl?raw";

  let g_view_mat: number;
  let g_perspective_mat: number;

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

    const v_grid = wasmStore.exports.getGridVerts();
    const t_grid = wasmStore.exports.getGridTriangles();

    const v_grid_view = Reader(
      v_grid,
      VEC3_WIDTH * 4,
      Float32Array,
      wasmStore.exports
    );
    const t_grid_view = Reader(
      t_grid,
      VEC3_WIDTH * 2,
      Uint16Array,
      wasmStore.exports
    );

    const gl = initCanvas(canvas.value);
    const shaderProgram = initShaderProgram(gl, vsSource, fsSource);
    gl.useProgram(shaderProgram);
    const grid_buffer = gl.createBuffer();

    void setupUniforms(gl, shaderProgram, prefs);

    const render = () => {
      void clear(gl);
      void wasmStore.exports.updateCamera();
      g_view_mat = wasmStore.exports.returnViewMatrix();
      g_perspective_mat = wasmStore.exports.returnPerspectiveMatrix();

      const grid_quad_ptr = wasmStore.exports.generateAndReturnGridQuad(
        prefs.gridSize
      );
      const grid_model_mat = Reader(
        grid_quad_ptr,
        16,
        Float32Array,
        wasmStore.exports
      );

      const cam_pos = wasmStore.exports.getCameraPos();
      const cam_pos_view = Reader(
        cam_pos,
        VEC3_WIDTH,
        Float32Array,
        wasmStore.exports
      );

      const view_mat = Reader(g_view_mat, 16, Float32Array, wasmStore.exports);
      const proj_mat = Reader(
        g_perspective_mat,
        16,
        Float32Array,
        wasmStore.exports
      );

      gl.disable(gl.CULL_FACE);
      drawGridQuad(
        gl,
        shaderProgram,
        cam_pos_view,
        v_grid_view,
        t_grid_view,
        grid_model_mat,
        view_mat,
        proj_mat
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

  <Tools />
  <!-- Canvas area -->
  <div class="relative">
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
