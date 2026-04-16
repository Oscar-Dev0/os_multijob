/**
 * Mock para previsualizar la NUI en navegador.
 * Solo se activa si NO estamos dentro de FiveM.
 */

const isEnvBrowser = () => !(window).invokeNative;

if (isEnvBrowser()) {
    // ── Locales mock ──
    window.MOCK_LOCALES = {
        es: {
            app_title: 'Empleos',
            app_subtitle: 'Gestiona roles, cambia servicio y limpia slots.',
            enter_duty: 'Entrar de servicio',
            exit_duty: 'Salir de servicio',
            select_job: 'Seleccionar',
            remove_job: 'Eliminar',
            popup_remove_title: 'Eliminar trabajo',
            popup_remove_desc: '¿Eliminar %s de tu lista?',
            popup_cancel: 'Cancelar',
            popup_confirm: 'Confirmar',
            active_label: 'TRABAJO ACTUAL',
            other_label: 'OTROS TRABAJOS',
            no_jobs: 'No tienes otros trabajos',
            civilian: 'Civil',
            civilian_desc: 'Rango: Civil [0] <br /> Salario: $0'
        },
        en: {
            app_title: 'Jobs',
            app_subtitle: 'Manage roles, toggle duty and clear slots.',
            enter_duty: 'Go on duty',
            exit_duty: 'Go off duty',
            select_job: 'Select',
            remove_job: 'Remove',
            popup_remove_title: 'Remove job',
            popup_remove_desc: 'Remove %s from your list?',
            popup_cancel: 'Cancel',
            popup_confirm: 'Confirm',
            active_label: 'CURRENT JOB',
            other_label: 'OTHER JOBS',
            no_jobs: "You don't have other jobs",
            civilian: 'Civilian',
            civilian_desc: 'Rank: Civilian [0] <br /> Salary: $0'
        }
    };

    // ── Datos mock ──
    const mockJobs = [
        {
            title: 'Policía',
            description: 'Rango: Oficial [2] <br /> Salario: $3500',
            disabled: true,
            jobName: 'police',
            duty: true,
        },
        {
            title: 'Civil',
            description: 'Rango: Civil [0] <br /> Salario: $0',
            disabled: false,
            jobName: 'unemployed',
            duty: false,
        },
        {
            title: 'Mecánico',
            description: 'Rango: Aprendiz [1] <br /> Salario: $1800',
            disabled: false,
            jobName: 'mechanic',
            duty: false,
        },
        {
            title: 'Ambulancia',
            description: 'Rango: Paramédico [3] <br /> Salario: $4000',
            disabled: false,
            jobName: 'ambulance',
            duty: false,
        },
        {
            title: 'Taxi',
            description: 'Rango: Conductor [0] <br /> Salario: $800',
            disabled: false,
            jobName: 'taxi',
            duty: false,
        },
    ];

    let dutyState = true;

    // ── Mock fetchNui ──
    window.fetchNui = async (event, data) => {
        console.log(`[mock] fetchNui("${event}",`, data, ')');

        switch (event) {
            case 'getLocale':
                return { locale: 'es' };

            case 'getJobs':
                return JSON.parse(JSON.stringify(mockJobs));

            case 'toggleDuty': {
                const active = mockJobs.find(j => j.disabled);
                if (active) {
                    dutyState = !dutyState;
                    active.duty = dutyState;
                }
                setTimeout(() => {
                    window.dispatchEvent(new MessageEvent('message', {
                        data: { action: 'update-jobs' }
                    }));
                }, 300);
                return true;
            }

            case 'changeJob': {
                const jobName = typeof data === 'string' ? data : data?.job;
                mockJobs.forEach(j => {
                    if (j.disabled) {
                        j.disabled = false;
                        j.duty = false;
                    }
                    if (j.jobName === jobName) {
                        j.disabled = true;
                        dutyState = false;
                        j.duty = false;
                    }
                });
                setTimeout(() => {
                    window.dispatchEvent(new MessageEvent('message', {
                        data: { action: 'update-jobs' }
                    }));
                }, 300);
                return true;
            }

            case 'removeJob': {
                const rName = typeof data === 'string' ? data : data?.job;
                const idx = mockJobs.findIndex(j => j.jobName === rName);
                if (idx !== -1) mockJobs.splice(idx, 1);
                return true;
            }

            default:
                console.warn(`[mock] evento no manejado: ${event}`);
                return {};
        }
    };

    // ── Mock setPopUp (lb-phone) ──
    window.setPopUp = (opts) => {
        console.log('[mock] setPopUp:', opts);
        const overlay = document.createElement('div');
        overlay.className = 'mock-popup-overlay';
        overlay.innerHTML = `
            <div class="mock-popup">
                <div class="mock-popup-title">${opts.title || ''}</div>
                <div class="mock-popup-desc">${opts.description || ''}</div>
                <div class="mock-popup-buttons">
                    ${(opts.buttons || []).map((b, i) => `
                        <button class="mock-popup-btn mock-popup-btn--${b.color || 'gray'}" data-idx="${i}">
                            ${b.title}
                        </button>
                    `).join('')}
                </div>
            </div>
        `;
        document.body.appendChild(overlay);

        overlay.querySelectorAll('.mock-popup-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const idx = parseInt(btn.dataset.idx);
                const cb = opts.buttons[idx]?.cb;
                if (cb) cb();
                overlay.remove();
            });
        });

        overlay.addEventListener('click', (e) => {
            if (e.target === overlay) overlay.remove();
        });
    };

    // ── Inyectar estilos del popup mock ──
    const style = document.createElement('style');
    style.textContent = `
        .mock-popup-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            backdrop-filter: blur(4px);
        }
        .mock-popup {
            background: #0c1528;
            border: 1px solid rgba(45,140,240,0.25);
            border-radius: 1rem;
            padding: 1.5rem 1.8rem;
            min-width: 260px;
            max-width: 340px;
            text-align: center;
            box-shadow: 0 20px 50px rgba(0,0,0,0.5);
        }
        .mock-popup-title {
            font-size: 18px;
            font-weight: 700;
            color: #e8f0ff;
            margin-bottom: 0.5rem;
        }
        .mock-popup-desc {
            font-size: 14px;
            color: #94a8c8;
            margin-bottom: 1.2rem;
        }
        .mock-popup-buttons {
            display: flex;
            gap: 0.6rem;
            justify-content: center;
        }
        .mock-popup-btn {
            padding: 0.6rem 1.2rem;
            border-radius: 0.6rem;
            border: none;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            transition: filter 120ms ease, transform 120ms ease;
            color: #fff;
        }
        .mock-popup-btn:hover {
            filter: brightness(1.15);
            transform: translateY(-1px);
        }
        .mock-popup-btn--red { background: #d94040; }
        .mock-popup-btn--green { background: #2d8cf0; }
        .mock-popup-btn--gray { background: #3a4a60; }
    `;
    document.head.appendChild(style);

    console.log('%c[multijob mock] %cActivo — previsualización en navegador',
        'color:#2d8cf0;font-weight:700', 'color:#94a8c8');
}
