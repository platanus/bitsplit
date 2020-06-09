<template>
  <div class="flex justify-center m-16">
    <div class="flex flex-col mb-6 mt-6">
      <div>
        <textField font-size="full" font-color="secondary">
          ¡Pago realizado con éxito!
        </textField>
      </div>
      <div>
        <textField>
          Monto: {{ this.userLastPaymentData.payment_amount }} BTC
        </textField>
        <textField>
          Correo: {{ this.userLastPaymentData.receiver_email }}
        </textField>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import textField from '../components/TextField';

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
