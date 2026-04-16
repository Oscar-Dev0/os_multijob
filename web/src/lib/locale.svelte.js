// Auto-import all JSON locale files from src/locales/
// To add a new language, just create a new .json file (e.g. fr.json, pt.json)
const modules = import.meta.glob('../locales/*.json', { eager: true });
const LOCALES = {};
for (const path in modules) {
  const lang = path.match(/\/(\w+)\.json$/)?.[1];
  if (lang) LOCALES[lang] = modules[path].default;
}

const fallback = LOCALES.es || LOCALES[Object.keys(LOCALES)[0]] || {};

let current = $state('es');
let strings = $state({ ...fallback });

export function setLocale(lang) {
  current = lang;
  strings = LOCALES[lang] || fallback;
}

export function getLocale() {
  return current;
}

/**
 * @param {string} key
 * @param  {...string} args
 * @returns {string}
 */
export function t(key, ...args) {
  let s = strings[key] || key;
  for (const a of args) s = s.replace('%s', a);
  return s;
}

export function getStrings() {
  return strings;
}
