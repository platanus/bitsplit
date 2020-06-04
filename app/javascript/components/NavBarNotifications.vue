\<template>
  <div>
    <button
      class="text-gray-500 rounded inline-flex items-center"
      @click="hidden = !hidden"
    >
      <svg
        class="fill-current w-4 h-4 mr-2"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 20 20"
      >
        <path
          d="M15 19a3 3 0 0 1-6 0H4a1 1 0 0 1 0-2h1v-6a7 7 0 0 1 4.02-6.34 3 3 0 0 1 5.96 0A7 7 0 0 1 19 11v6h1a1 1 0 0 1 0 2h-5zm-4 0a1 1 0 0 0 2 0h-2zm0-12.9A5 5 0 0 0 7 11v6h10v-6a5 5 0 0 0-4-4.9V5a1 1 0 0 0-2 0v1.1z"
        />
      </svg>
      <span>{{ unSeenNotifications.length }}</span>
    </button>
    <div v-show="!hidden" class="absolute bg-gray-400 mt-4 ml-2">
      <div
        class="absolute z-0 w-4 h-4 origin-center transform rotate-45 translate-x-5 -translate-y-2 bg-gray-400 border-t border-l border-gray-200 rounded-sm pointer-events-none"
      />
      <div v-show="!hasNotifications" class="m-2">
        No tienes notificaciones sin leer
      </div>
      <div v-show="hasNotifications" class="pr-2 h-64 overflow-y-auto">
        <ul
          v-for="notification in unSeenNotifications"
          :key="notification['.key']"
        >
          <li class="p-3 border-black border-solid hover:bg-gray-500 z-40">
            <div v-show="notification.type === 'payment'" class="flex flex-row">
              <RightArrow color="seaGreen" />
              <p class="pl-2 font-thin">
                Recibido BTC {{ notification.data.amount }}
              </p>
              <button @click="markAsSeen(notification['.key'])">
                <Cross class="ml-2 cursor-pointer" />
              </button>
            </div>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>
<script>
import { mapGetters, mapActions, mapState } from 'vuex';
import RightArrow from './icons/RightArrow';
import Cross from './icons/Cross';

export default {
  name: 'NavBarNotifications',
  components: {
    RightArrow,
    Cross,
  },
  data() {
    return {
      hidden: true,
    };
  },
  methods: {
    ...mapActions('notification', ['markAsSeen']),
    ...mapActions('user', ['getUserBudaBalance', 'getPayments']),
  },
  computed: {
    ...mapGetters('notification', ['unSeenNotifications']),
    ...mapState('notification', ['notifications']),

    hasNotifications() {
      return !!this.unSeenNotifications[0];
    },
  },
  watch: {
    unSeenNotifications(newNotifications, oldNotifications) {
      const nPaymentsOld = oldNotifications.filter(d => d.type === 'payment')
        .length;
      const nPaymentsNew = newNotifications.filter(d => d.type === 'payment')
        .length;

      // Recargo el balance si hay una notificacion tipo payment nueva
      if (nPaymentsNew > nPaymentsOld) {
        this.getUserBudaBalance();
        this.getPayments();
      }
    },
  },
};
</script>
