import Vue from 'vue/dist/vue.esm'
import Router from 'vue-router'

import SignIn from './SignIn.vue'
import SignUp from './SignUp.vue'
import Landing from './Landing.vue'
import Home from './Home.vue'
import BudaProfile from './BudaProfile.vue'
import Payment from './Payment.vue'

import { checkAuth, checkNoAuth } from '../helpers'

Vue.use(Router)

const router = new Router({
  mode: 'history',
  routes: [
    { path: '/', component: Landing },
    { path: '/sign-in', component: SignIn, beforeEnter: checkNoAuth },
    { path: '/sign-up', component: SignUp, beforeEnter: checkNoAuth },
    { path: '/home', component: Home, beforeEnter: checkAuth },
    { path: '/buda', component: BudaProfile, beforeEnter: checkAuth },
    { path: '/payment', component: Payment , beforeEnter: checkAuth }
  ]
})

export default router