<script setup lang="ts">
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
    class="menu absolute menu-md max-w-fit bg-base-200 z-10 rounded-box"
    :style="{
      top: mouse_controller?.cm.y + 'px',
      left: mouse_controller?.cm.x + 'px',
    }"
  >
    <li><a>Medium 1</a></li>
    <li><a>Medium 2</a></li>
  </ul>
</template>
