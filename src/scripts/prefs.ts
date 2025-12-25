interface Prefs {
  canvasWidth: number;
  canvasHeight: number;
}

const defaultPrefs: Prefs = {
  canvasWidth: screen.width,
  canvasHeight: screen.height,
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
