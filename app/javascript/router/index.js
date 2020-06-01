import Vue from 'vue/dist/vue.esm';
import Router from 'vue-router';

import SignIn from './SignIn.vue';
import SignUp from './SignUp.vue';
import Landing from './Landing.vue';
import Home from './Home.vue';
import BudaIndex from './BudaIndex.vue';
import PaymentIndex from './PaymentIndex.vue';
import Profile from './Profile.vue';
import OnBoarding from './OnBoarding.vue';

import SplitwiseLink from '../components/profile/SplitwiseLink.vue';
import ProfileHome from '../components/profile/ProfileHome.vue';
import ProfileSettings from '../components/profile/ProfileSettings.vue';
import ProfileOpenNode from '../components/profile/ProfileOpenNode.vue';

import { checkAuth, checkNoAuth, checkBudaAuth } from '../helpers';

Vue.use(Router);

const router = new Router({
  mode: 'history',
  routes: [
    { path: '/', component: Landing, beforeEnter: checkNoAuth },
    { path: '/sign-in', component: SignIn, beforeEnter: checkNoAuth },
    { path: '/sign-up', component: SignUp, beforeEnter: checkNoAuth },
    { path: '/onboarding', component: OnBoarding, beforeEnter: checkAuth },
    { path: '/home', component: Home, beforeEnter: checkAuth },
    { path: '/buda', component: BudaIndex, beforeEnter: checkAuth },
    {
      path: '/profile/',
      component: Profile,
      beforeEnter: checkAuth,
      children: [
        {
          path: '',
          component: ProfileHome,
        },
        {
          path: 'buda',
          component: BudaIndex,
        },
        {
          path: 'splitwise',
          component: SplitwiseLink,
        },
        {
          path: 'opennode',
          component: ProfileOpenNode,
        },
        {
          path: 'settings',
          component: ProfileSettings,
        },
      ],
    },
    {
      path: '/payment',
      component: PaymentIndex,
      beforeEnter: checkAuth && checkBudaAuth,
    },
  ],
});

export default router;
