<template>
  <div class="items-center h-screen w-full bg-primary p-12 mt-24 text-center">
    <textField font-size="full">
      ¡Deuda saldada con éxito!
    </textField>
    <div>
      <textField>
        Monto: {{ this.userLastPaymentData.amount_btc }} BTC
      </textField>
      <textField>
        Receptor:
        {{
          this.userLastPaymentData.first_name +
          ' ' +
          this.userLastPaymentData.last_name
        }}
      </textField>
      <textField>
        Correo: {{ this.userLastPaymentData.receiver_email }}
      </textField>
    </div>
    <router-link to="/">
      <button class="btn p-2">
        Ir a Bitsplit
      </button>
    </router-link>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import textField from '../TextField';

export default {
  name: 'SplitwisePaymentConfirm',
  data() {
    return {
      routeName: 'SplitwisePaymentRoute',
      date: null,
    };
  },
  components: {
    textField,
  },
  computed: {
    ...mapState('user', ['currentUser', 'userLastPaymentData']),
  },
};
</script>
