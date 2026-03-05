<script setup lang="ts">
  import pkg from "../../package.json";
  import { BadgeQuestionMark } from "lucide-vue-next";
</script>

<template>
  <footer
    class="footer font-mono z-20 fixed bottom-0 sm:footer-horizontal bg-base-100 text-neutral-900 items-center p-4"
  >
    <aside class="grid-flow-col items-center">
      <div class="flex items-center gap-2 text-neutral-500">
        <p class="uppercase">Shortcuts</p>
        <kbd class="kbd kbd-sm bg-blue-200">Shift + F</kbd>
      </div>
    </aside>
    <nav
      class="text-black grid-flow-col gap-4 md:place-self-center md:justify-self-end"
    >
      <p>FPS: 60.0</p>
      <p class="text-blue-400">v{{ pkg.version }}</p>
    </nav>
  </footer>
</template>
