import './styles/global.css';
import './styles/layouts/side-right.css';
import './styles/layouts/side-left.css';
import './styles/layouts/fullscreen.css';
import './styles/layouts/compact.css';
import './styles/layouts/centered.css';
import './styles/layouts/floating.css';
import './styles/layouts/bottom.css';
import { isBrowser } from './lib/fetchNui.js';
import { setupMock } from './lib/mock.js';
import { mount } from 'svelte';
import App from './App.svelte';

if (isBrowser()) setupMock();

mount(App, { target: document.getElementById('root') });
