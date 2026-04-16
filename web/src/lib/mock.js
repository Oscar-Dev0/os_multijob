const mockJobs = [
  { title: 'Policía', description: 'Rango: Oficial [2] <br /> Salario: $3500', disabled: true, jobName: 'police', duty: true },
  { title: 'Civil', description: 'Rango: Civil [0] <br /> Salario: $0', disabled: false, jobName: 'unemployed', duty: false },
  { title: 'Mecánico', description: 'Rango: Aprendiz [1] <br /> Salario: $1800', disabled: false, jobName: 'mechanic', duty: false },
  { title: 'Ambulancia', description: 'Rango: Paramédico [3] <br /> Salario: $4000', disabled: false, jobName: 'ambulance', duty: false },
  { title: 'Taxi', description: 'Rango: Conductor [0] <br /> Salario: $800', disabled: false, jobName: 'taxi', duty: false },
];

let dutyState = true;

export function setupMock() {
  if (typeof window === 'undefined' || window.invokeNative) return;

  window.__mockFetchNui = async (event, data) => {
    console.log(`[mock] ${event}`, data);
    switch (event) {
      case 'getLocale':
        return { locale: 'es' };

      case 'getJobs':
        return JSON.parse(JSON.stringify(mockJobs));

      case 'toggleDuty': {
        const active = mockJobs.find(j => j.disabled);
        if (active) { dutyState = !dutyState; active.duty = dutyState; }
        return true;
      }

      case 'changeJob': {
        const name = typeof data === 'string' ? data : data?.job;
        mockJobs.forEach(j => {
          if (j.disabled) { j.disabled = false; j.duty = false; }
          if (j.jobName === name) { j.disabled = true; j.duty = false; dutyState = false; }
        });
        return true;
      }

      case 'removeJob': {
        const rn = typeof data === 'string' ? data : data?.job;
        const idx = mockJobs.findIndex(j => j.jobName === rn);
        if (idx !== -1) mockJobs.splice(idx, 1);
        return true;
      }

      case 'closeStandalone':
        return 'ok';

      default:
        return {};
    }
  };

  // Auto-open in browser
  setTimeout(() => {
    window.dispatchEvent(new MessageEvent('message', {
      data: { action: 'open', style: 'side-right' },
    }));
  }, 100);

  console.log('%c[multijob mock] %cActivo', 'color:#2d8cf0;font-weight:700', 'color:#94a8c8');
}
