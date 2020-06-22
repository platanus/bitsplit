<template>
  <div class="flex justify-center m-16">
    <div class="flex flex-col mb-6 mt-6">
      <div>
        <textField font-size="full" font-color="secondary">
          ¡Deuda saldada con éxito!
        </textField>
      </div>
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
    </div>
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
