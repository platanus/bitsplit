import Vue from 'vue/dist/vue.esm';
import Router from 'vue-router';

import SplitwiseConnectionReady from './SplitwiseConnectionReady.vue';
import SignIn from './SignIn.vue';
import SignUp from './SignUp.vue';
import Landing from './Landing.vue';
import Home from './Home.vue';
import BudaIndex from './BudaIndex.vue';
import PaymentIndex from './PaymentIndex.vue';
import SplitwiseIndex from './SplitwiseIndex.vue';
import SplitwisePaymentIndex from './SplitwisePaymentIndex.vue';
import Profile from './Profile.vue';
import OnBoarding from './OnBoarding.vue';
import PaymentsHistory from './PaymentsHistory';
import RecoverAccount from './RecoverAccount';
import NewPassword from './NewPassword';

import SplitwiseLink from '../components/profile/SplitwiseLink.vue';
import ProfileHome from '../components/profile/ProfileHome.vue';
import ProfileSettings from '../components/profile/ProfileSettings.vue';
import ProfileOpenNode from '../components/profile/ProfileOpenNode.vue';

import {
  checkAuth,
  checkNoAuth,
  checkSplitwiseData,
  checkSplitwiseAuth,
} from '../helpers';

Vue.use(Router);

const router = new Router({
  mode: 'history',
  routes: [
    { path: '/', component: Landing, beforeEnter: checkNoAuth },
    { path: '/sign-in', component: SignIn, beforeEnter: checkNoAuth },
    { path: '/sign-up', component: SignUp, beforeEnter: checkNoAuth },
    { path: '/recover', component: RecoverAccount, beforeEnter: checkNoAuth },
    { path: '/new-password', component: NewPassword, beforeEnter: checkNoAuth },
    { path: '/new-account', component: NewPassword, beforeEnter: checkNoAuth },
    { path: '/onboarding', component: OnBoarding, beforeEnter: checkAuth },
    { path: '/home', component: Home, beforeEnter: checkAuth },
    { path: '/splitwise-connection', component: SplitwiseConnectionReady },
    {
      path: '/payments-history',
      component: PaymentsHistory,
      beforeEnter: checkAuth,
    },
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
          path: 'wallet',
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
      beforeEnter: checkAuth,
    },
    {
      path: '/splitwise',
      component: SplitwiseIndex,
      beforeEnter: checkAuth && checkSplitwiseAuth,
    },
    {
      path: '/splitwisepayment',
      component: SplitwisePaymentIndex,
      beforeEnter: checkAuth && checkSplitwiseAuth && checkSplitwiseData,
    },
  ],
});

export default router;
