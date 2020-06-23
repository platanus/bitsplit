<template>
  <div class="items-center h-screen w-full bg-primary p-12 mt-24 text-center">
    <textField font-size="full">
      ¡Pago realizado con éxito!
    </textField>
    <div>
      <textField>
        Monto: {{ this.userLastPaymentData.payment_amount }} BTC
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
  name: 'PaymentConfirm',
  data() {
    return {
      routeName: 'PaymentRoute',
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
