\<template>
  <div>
    <button
      class="text-gray-500 rounded flex items-center"
      @click="hidden = !hidden"
    >
      <i class="material-icons text-center mr-2">notifications</i>
      <span>{{ unSeenNotifications.length }}</span>
    </button>
    <div v-show="!hidden" class="absolute bg-gray-400 mt-12 ml-2">
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
              <i class="material-icons cursor-pointer text-green-700">east</i>
              <p v-if="notification.data.sender" class="pl-2 font-thin">
                {{
                  `${notification.data.sender} te ha enviado ${notification.data.amount} BTC`
                }}
              </p>
              <p v-else class="pl-2 font-thin">
                {{ `Has recibido ${notification.data.amount} BTC` }}
              </p>
              <button @click="markAsSeen(notification['.key'])">
                <i class="material-icons ml-2 cursor-pointer">cancel</i>
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

export default {
  name: 'NavBarNotifications',
  data() {
    return {
      hidden: true,
    };
  },
  methods: {
    ...mapActions('notification', ['markAsSeen']),
    ...mapActions('user', ['getCurrentUser', 'getUserBalance', 'getPayments']),
  },
  computed: {
    ...mapGetters('notification', ['unSeenNotifications']),
    ...mapState('notification', ['notifications']),
    ...mapState('user', ['currentUser']),

    hasNotifications() {
      return !!this.unSeenNotifications[0];
    },
  },
  // Cuando se carga la pagina con un usuario ingresado
  created() {
    this.getCurrentUser({
      authentication_token: this.currentUser.authentication_token,
    });
    this.getUserBalance();
  },
  // Cuando se cambia de ruta con un usuario ingresado
  watch: {
    $route() {
      this.getCurrentUser({
        authentication_token: this.currentUser.authentication_token,
      });
      this.getUserBalance();
    },
    unSeenNotifications(newNotifications, oldNotifications) {
      const nPaymentsOld = oldNotifications.filter(d => d.type === 'payment')
        .length;
      const nPaymentsNew = newNotifications.filter(d => d.type === 'payment')
        .length;

      // Recargo el balance si hay una notificacion tipo payment nueva
      if (nPaymentsNew > nPaymentsOld) {
        this.getUserBalance();
        this.getPayments();
      }
    },
  },
};
</script>
