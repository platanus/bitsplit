import Vue from 'vue/dist/vue.esm'
import Router from 'vue-router'

import SignIn from './SignIn.vue'
import SignUp from './SignUp.vue'
import Landing from './Landing.vue'
import Home from './Home.vue'
import BudaIndex from './BudaIndex.vue'
import PaymentIndex from './PaymentIndex.vue'

import { checkAuth, checkNoAuth, checkBudaAuth } from '../helpers'

Vue.use(Router)

const router = new Router({
  mode: 'history',
  routes: [
    { path: '/', component: Landing, beforeEnter: checkNoAuth },
    { path: '/sign-in', component: SignIn, beforeEnter: checkNoAuth },
    { path: '/sign-up', component: SignUp, beforeEnter: checkNoAuth },
    { path: '/home', component: Home, beforeEnter: checkAuth },
    { path: '/buda', component: BudaIndex, beforeEnter: checkAuth },
    {
      path: '/payment',
      component: PaymentIndex,
      beforeEnter: checkAuth && checkBudaAuth
    }
  ]
})

export default router
