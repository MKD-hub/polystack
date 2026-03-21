<script setup lang="ts">
  import pkg from "../../package.json";
  import { BadgeQuestionMark } from "lucide-vue-next";
</script>

<template>
  <footer class="flex items-center justify-between border-t border-slate-200 bg-[#f8fbff] px-5 py-1.5 text-xs text-slate-500">
    <div class="flex items-center gap-5">
      <span class="font-semibold text-blue-700">ENGINE READY</span>
      <span>60 FPS</span>
      <span>v{{ pkg.version }}</span>
    </div>
    <div class="flex items-center gap-5">
      <span>DOCS</span>
      <span>FEEDBACK</span>
    </div>
  </footer>
</template>
