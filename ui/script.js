// ── Locale system ──
const LOCALES = {
    es: {
        app_title: "Empleos",
        app_subtitle: "Gestiona roles, cambia servicio y limpia slots.",
        enter_duty: "Entrar de servicio",
        exit_duty: "Salir de servicio",
        select_job: "Seleccionar",
        remove_job: "Eliminar trabajo",
        popup_remove_title: "Eliminar trabajo",
        popup_remove_desc: "Quitar %s",
        popup_cancel: "Cancelar",
        popup_confirm: "Confirmar",
        civilian: "Civil",
        civilian_desc: "Rango: Civil [0] <br /> Salario: $0"
    },
    en: {
        app_title: "Jobs",
        app_subtitle: "Manage roles, toggle duty and clear slots.",
        enter_duty: "Go on duty",
        exit_duty: "Go off duty",
        select_job: "Select",
        remove_job: "Remove job",
        popup_remove_title: "Remove job",
        popup_remove_desc: "Remove %s",
        popup_cancel: "Cancel",
        popup_confirm: "Confirm",
        civilian: "Civilian",
        civilian_desc: "Rank: Civilian [0] <br /> Salary: $0"
    }
};

let i18n = LOCALES.es;

function setLocale(lang) {
    i18n = LOCALES[lang] || LOCALES.es;
    applyI18n();
}

function t(key, ...args) {
    let str = i18n[key] || key;
    if (args.length) {
        args.forEach(arg => {
            str = str.replace('%s', arg);
        });
    }
    return str;
}

function applyI18n() {
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.getAttribute('data-i18n');
        el.textContent = t(key);
    });
}

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
window.addEventListener("load", () => {
    fetchNui('getLocale', {}).then(data => {
        const lang = (data && data.locale) || 'es';
        setLocale(lang);
        fetchNui('getJobs', {}).then(loadJobs);
    });

    $("body").on("click", ".activeJob-status", function(e) {
        e.preventDefault();
        fetchNui('toggleDuty', {});
    });

    $("body").on("click", ".job-status", function(e) {
        e.preventDefault();
        fetchNui('changeJob', this.dataset.job);
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
                        fetchNui('removeJob', this.dataset.job);
                        $(this).parent().fadeOut();
                    }
                }
            ]
        })
    });
});

window.addEventListener("message", (event) => {
    if(event.data.action == "update-jobs") {
        fetchNui('getJobs', {}).then(loadJobs);
    };
});