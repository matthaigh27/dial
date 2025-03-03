class DialPanel extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: 'open' });

    this._data = null;
  }

  connectedCallback() {
    this.render();
    this.renderDetails();
    this.addEventListeners();
  }

  get data() {
    if (this._data) return this._data;
    try {
      this._data = JSON.parse(this.getAttribute('data-dial') || '{}');
    } catch (e) {
      console.error('[Dial] Error parsing Dial panel data:', e);
      this._data = {};
    }

    return this._data;
  }

  render() {
    const data = this.data;

    this.shadowRoot.innerHTML = `
      <link rel="stylesheet" href="dial/assets/dial.css"></link>
      <div class="dial-toggle">
        <div class="dial-panel">
          <div class="dial-header">
            <div class="dial-header-content">
              <span>${data.rails?.controller}#${data.rails?.action}</span> |
              <span>${data.request?.timing || 0}ms</span> |
              ${this.formatProfileLink(data)}
            </div>
            <button class="dial-options" title="Dial panel Options">⋮</button>
          </div>
          <hr>
          <div class="dial-body"></div>
        </div>
      </div>
    `;
  }

  renderOptions() {
    const dialBody = this.shadowRoot.querySelector('.dial-body');

    dialBody.innerHTML = `
      <div>
        <button class="dial-option" title="Hide Dial">Hide</button>
      </div>
    `;
  }

  renderDetails() {
    const data = this.data;
    const dialBody = this.shadowRoot.querySelector('.dial-body');

    dialBody.innerHTML = `
      <div class="dial-preview">
        <span><b>Rails version:</b> ${data.rails?.version || 'N/A'}</span>
        <span><b>Rack version:</b> ${data.rack?.version || 'N/A'}</span>
        <span class="asd"><b>Ruby version:</b> ${data.ruby?.version || 'N/A'}</span>
      </div>

      <div class="dial-details">
        <details>
          <summary>N+1s</summary>
          <div class="section query-logs">
            ${this.formatQueryLogs(data.queryLogs || [])}
          </div>
        </details>

        <hr>

        <details>
          <summary>Server timing</summary>
          <div class="section">
            ${this.formatServerTiming(data.serverTiming || {})}
          </div>
        </details>

        <hr>

        <details>
          <summary>RubyVM stat</summary>
          <div class="section">
            ${this.formatObjectStats(data.rubyVmStat || {})}
          </div>
        </details>

        <hr>

        <details>
          <summary>GC stat</summary>
          <div class="section">
            ${this.formatObjectStats(data.gcStat || {})}
          </div>
        </details>

        <hr>

        <details>
          <summary>GC stat heap</summary>
          <div class="section">
            ${this.formatGcStatHeap(data.gcStatHeap || {})}
          </div>
        </details>
      </div>
    `
  }

  formatProfileLink(data) {
    if (!data.profile?.uuid || !data.profile?.host) return '';

    const urlBase = location.protocol + '//' + data.profile.host + '/dial';
    const profileOutUrl = encodeURIComponent(`${urlBase}/profile?uuid=${data.profile.uuid}`);

    return `<a href='https://vernier.prof/from-url/${profileOutUrl}' target='_blank'>View profile</a>`;
  }

  addEventListeners() {
    const preview = this.shadowRoot.querySelector('.dial-preview');
    const details = this.shadowRoot.querySelector('.dial-details');
    const options = this.shadowRoot.querySelector('.dial-options');

    options.addEventListener('click', () => {
      this.renderOptions();
    });


    preview.addEventListener('click', () => {
      details.style.display = details.style.display === 'block' ? 'none' : 'block';
    });

    // Close when clicking outside
    document.addEventListener('click', (event) => {
      if (!this.contains(event.target) && details.style.display === 'block') {
        details.style.display = 'none';

        const detailsElements = details.querySelectorAll('details');
        detailsElements.forEach(detail => {
          detail.removeAttribute('open');
        });
      }
    });
  }

  formatQueryLogs(queryLogs) {
    if (!queryLogs.length) return '<span>N/A</span>';

    return queryLogs.map(([queries, stackLines]) => {
      const summary = queries.shift() || '';

      return `
        <details>
          <summary>${summary}</summary>
          <div class="section query-logs">
            ${queries.map(query => `<span>${query}</span>`).join('')}
            ${stackLines.map(line => `<span>${line}</span>`).join('')}
          </div>
        </details>
      `;
    }).join('');
  }

  formatServerTiming(serverTiming) {
    if (Object.keys(serverTiming).length === 0) return '<span>N/A</span>';

    return Object.entries(serverTiming)
      .sort(([, a], [, b]) => b - a)
      .map(([event, timing]) => `<span><b>${event}:</b> ${timing}</span>`)
      .join('');
  }

  formatObjectStats(stats) {
    return Object.entries(stats)
      .map(([key, value]) => `<span><b>${key}:</b> ${value}</span>`)
      .join('');
  }

  formatGcStatHeap(heapStats) {
    return Object.entries(heapStats)
      .map(([slot, stats]) => `
        <div class="section">
          <span><u>Heap slot ${slot}</u></span>
          <div class="section">
            ${Object.entries(stats).map(([key, value]) => `<span><b>${key}:</b> ${value}</span>`).join('')}
          </div>
        </div>
      `)
      .join('');
  }
}

customElements.define('dial-panel', DialPanel);
