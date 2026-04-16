// ── Locale system ──
let LOCALES = {};
let i18n = {};

async function loadLocales() {
  try {
    const res = await fetch('../locales/es.json');
    LOCALES.es = await res.json();
  } catch { LOCALES.es = {}; }
  try {
    const res = await fetch('../locales/en.json');
    LOCALES.en = await res.json();
  } catch { LOCALES.en = {}; }
    if ((!LOCALES.es || !Object.keys(LOCALES.es).length) && window.MOCK_LOCALES?.es) {
        LOCALES.es = window.MOCK_LOCALES.es;
    }
    if ((!LOCALES.en || !Object.keys(LOCALES.en).length) && window.MOCK_LOCALES?.en) {
        LOCALES.en = window.MOCK_LOCALES.en;
    }
  i18n = LOCALES.es;
}

function setLocale(lang) {
  i18n = LOCALES[lang] || LOCALES.es || {};
  applyI18n();
}

function t(key, ...args) {
  let str = i18n[key] || key;
  for (const a of args) str = str.replace('%s', a);
  return str;
}

function applyI18n() {
  document.querySelectorAll('[data-i18n]').forEach(el => {
    el.textContent = t(el.getAttribute('data-i18n'));
  });
}

// ── NUI fetch ──
const RES = (typeof GetParentResourceName === 'function')
  ? GetParentResourceName()
  : 'os_multijob';

async function realFetchNui(event, data) {
  try {
    const resp = await fetch('https://' + RES + '/' + event, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(data || {}),
    });
    return await resp.json();
  } catch {
    return null;
  }
}

const nuiFetch = (typeof window.fetchNui === 'function')
    ? window.fetchNui
        : realFetchNui;


// ── Job rendering ──
async function addJob(info) {
    if (info.disabled) {
        const container = document.querySelector('#activeJob-card');
        container.innerHTML = '';

        let deleteButton = `<div class="job-remove" data-job="${info.jobName}" data-title="${info.title}">${t('remove_job')}</div>`;
        if (info.jobName == 'unemployed') {
            deleteButton = '';
        }
         
        var status = info.duty ? t('exit_duty') : t('enter_duty');
        let StatusButton = `<div class="activeJob-status" data-job="${info.jobName}">${status}</div>`;
        if (info.jobName == 'unemployed') {
            StatusButton = '';
        }

        var jobPanel = `
        <div class="activeJob-name">${info.title}</div>
        <div class="activeJob-grade">${info.description}</div>
        ${StatusButton}
        ${deleteButton}`;
        $('#activeJob-card').append(jobPanel);

    } else {
        let deleteButton = `<div class="job-remove" data-job="${info.jobName}" data-title="${info.title}">${t('remove_job')}</div>`;
        if (info.jobName == 'unemployed') {
            deleteButton = '';
        }
        var jobPanel = `
        <div class="job-card">
            <div class="job-name">${info.title}</div>
            <div class="job-grade">${info.description}</div>
            <div class="job-status" data-job="${info.jobName}">${t('select_job')}</div>
            ${deleteButton}
        </div>`;
        
        $('#jobs').append(jobPanel);
    }
};

async function loadJobs(jobs) {
    const elementsToRemove = document.querySelectorAll('.job-card');
    elementsToRemove.forEach(element => {
        element.remove();
    });

    const jobList = Array.isArray(jobs)
        ? jobs
        : (jobs && Array.isArray(jobs.jobs) ? jobs.jobs : []);

    if (!jobList.length) {
        jobList.push({
            title: t('civilian'),
            description: t('civilian_desc'),
            disabled: false,
            jobName: 'unemployed',
            duty: false,
        });
    }

    jobList.sort((a, b) => {
        const titleA = a.title.toLowerCase();
        const titleB = b.title.toLowerCase();    
        if (titleA < titleB) return -1;
        if (titleA > titleB) return 1;
        return 0;
    });

    for (let i = 0; i < jobList.length; i++) {
        addJob(jobList[i]);
    }
};

// ── Init ──
window.addEventListener("load", async () => {
    await loadLocales();
    nuiFetch('getLocale', {}).then(data => {
        const lang = (data && data.locale) || 'es';
        setLocale(lang);
        nuiFetch('getJobs', {}).then(loadJobs);
    });

    $("body").on("click", ".activeJob-status", function(e) {
        e.preventDefault();
        nuiFetch('toggleDuty', {});
    });

    $("body").on("click", ".job-status", function(e) {
        e.preventDefault();
        nuiFetch('changeJob', this.dataset.job);
    });

    $("body").on("click", ".job-remove", function(e) {
        e.preventDefault();
        setPopUp({
            title: t('popup_remove_title'),
            description: t('popup_remove_desc', this.dataset.title),
            buttons: [
                {
                    title: t('popup_cancel'),
                    color: "red",
                },
                {
                    title: t('popup_confirm'),
                    color: "green",
                    cb: () => {
                        nuiFetch('removeJob', this.dataset.job);
                        $(this).parent().fadeOut();
                    }
                }
            ]
        })
    });
});

window.addEventListener("message", (event) => {
    if(event.data.action == "update-jobs") {
        nuiFetch('getJobs', {}).then(loadJobs);
    };
});