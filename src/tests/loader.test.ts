import { expect, test } from "vitest";
import { loadWasm } from "@/scripts/loader";
import { wasmStore } from "@/scripts/wasm-store";
import { ArrayWriter, Reader } from "@/utils/utils";
import { loadPrefs } from "@/scripts/prefs";

loadWasm();

const prefs = loadPrefs();

/**
 * @test log_editor_config
 */
test("log_editor_config", () => {
  if (wasmStore.exports) {
    wasmStore.exports.getEditorConfig(
      prefs.fov,
      prefs.aspect,
      prefs.canvasWidth,
      prefs.canvasHeight
    );
  }
});
