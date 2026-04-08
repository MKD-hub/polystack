<script setup lang="ts">
  import {
    Clapperboard,
    BadgePlus,
    Import,
    ClipboardCopy,
    ClipboardPaste,
    Focus,
    Scan,
    Box,
    Pyramid,
    Torus,
    Circle,
  } from "lucide-vue-next";
  import MouseController from "@/controllers/mouse.controller.ts";
  import { defineProps, watchEffect } from "vue";
  const { mouse_controller } = defineProps<{
    mouse_controller: MouseController | undefined;
  }>();

  watchEffect(() => {
    console.log(mouse_controller?.cm.x, mouse_controller?.cm.y);
  });
</script>

<template>
  <!-- context menu -->
  <!-- get mouse pos -->
  <ul
    v-if="mouse_controller?.cm.open"
    class="menu w-73 absolute menu-md bg-base-200 z-10 rounded-box"
    :style="{
      top: mouse_controller?.cm.y + 'px',
      left: mouse_controller?.cm.x + 'px',
    }"
  >
    <li>
      <details open>
        <summary><BadgePlus size="16" />Create</summary>
        <ul>
          <li>
            <a><Box size="16" />Cube</a>
          </li>
          <li>
            <a><Pyramid size="16" />Pyramid</a>
          </li>
          <li>
            <a><Circle size="16" />Sphere</a>
          </li>
          <li>
            <a><Torus size="16" />Torus</a>
          </li>
        </ul>
      </details>
    </li>
    <li>
      <details open>
        <summary><Clapperboard size="16" />Camera Controls</summary>
        <ul>
          <li>
            <a><Focus size="16" />Focus Camera on Object</a>
          </li>
          <li>
            <a><Scan size="16" />Focus Camera on World Origin</a>
          </li>
        </ul>
      </details>
    </li>
    <!-- <li> -->
    <!--   <a><Import size="16" />Import</a> -->
    <!-- </li> -->
    <!-- <li> -->
    <!--   <a><ClipboardCopy size="16" />Copy</a> -->
    <!-- </li> -->
    <!-- <li> -->
    <!--   <a><ClipboardPaste size="16" />Paste</a> -->
    <!-- </li> -->
  </ul>
</template>
