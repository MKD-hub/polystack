export interface Prefs {
  canvasWidth: number;
  canvasHeight: number;
  aspect: number;
  gridSize: number;
  minorGridLineThickness: number;
  majorGridLineThickness: number;
  gridSpacingMajor: number;
  gridSpacingMinor: number;
  sensitivity: number;
  fov: number;
  near: number;
  far: number;
  gridColor: { r: number; g: number; b: number; a: number };
}

const defaultPrefs: Prefs = {
  canvasWidth: document.documentElement.clientWidth * window.devicePixelRatio,
  canvasHeight: document.documentElement.clientHeight * window.devicePixelRatio,
  aspect: 16 / 9,
  gridSize: 2000,
  minorGridLineThickness: 0.003,
  majorGridLineThickness: 0.009,
  gridSpacingMajor: 5.0,
  gridSpacingMinor: 1.0,
  sensitivity: 0.001,
  fov: 45,
  near: 0.001,
  far: 4000.0,
  gridColor: { r: 0.624, g: 0.651, b: 0.678, a: 1 },
};

export function loadPrefs(parentContainer?: HTMLElement): Prefs {
  const stored = localStorage.getItem("modellerPrefs");
  if (stored) {
    try {
      return JSON.parse(stored) as Prefs;
    } catch {
      return defaultPrefs;
    }
  }

  if (parentContainer) {
    const rect: DOMRect = parentContainer.getBoundingClientRect();
    const w = Math.floor(rect.width);
    const h = Math.floor(rect.height);
    const a = w / h;

    console.log(w, h, a);
    return {
      ...defaultPrefs,
      canvasWidth: w,
      canvasHeight: h,
      aspect: a,
    };
  }

  return defaultPrefs;
}

export function savePrefs(prefs: Prefs) {
  localStorage.setItem("modellerPrefs", JSON.stringify(prefs));
}
