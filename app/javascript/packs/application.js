import Vue from 'vue/dist/vue.esm'
import Router from 'vue-router'

// import App from '../app.vue'
import store from './../store'

import '../css/application.css'

import SignIn from './../components/SignIn.vue'
import SignUp from './../components/SignUp.vue'
import Landing from './../components/Landing.vue'
import Home from './../components/Home.vue'

import { checkAuth, checkNoAuth } from './../helpers'

import App from './../app.vue'

Vue.config.devtools = true
Vue.use(Router)

const router = new Router({
  mode: 'history',
  routes: [
    { path: '/', component: Landing },
    { path: '/sign-in', component: SignIn, beforeEnter: checkNoAuth },
    { path: '/sign-up', component: SignUp, beforeEnter: checkNoAuth },
    { path: '/home', component: Home, beforeEnter: checkAuth }
  ]
})

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    router,
    store,
    el: '#vue-app',
    render: h => h(App)
  })

  return app
})
