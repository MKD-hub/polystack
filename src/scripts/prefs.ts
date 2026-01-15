export interface Prefs {
  canvasWidth: number;
  canvasHeight: number;
  cellSize: number;
  lineThickness: number;
}

const defaultPrefs: Prefs = {
  canvasWidth: screen.width,
  canvasHeight: screen.height,
  cellSize: 1.0,
  lineThickness: 1.0,
};

export function loadPrefs(): Prefs {
  const stored = localStorage.getItem("modellerPrefs");
  if (stored) {
    try {
      return JSON.parse(stored) as Prefs;
    } catch {
      return defaultPrefs;
    }
  }
  return defaultPrefs;
}

export function savePrefs(prefs: Prefs) {
  localStorage.setItem("modellerPrefs", JSON.stringify(prefs));
}
