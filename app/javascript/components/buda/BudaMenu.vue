<template>
  <div>
    <center>
      <div class="w-full max-w-xs pb-16">
        <div>
          <textField>
            ¡Ya estás conectado a una cuenta Buda! ¿Qué desear hacer?
          </textField>
        </div>
        <div class="inline">
          <div class="pb-6">
            <submitButton
              @do-click="change('BudaForm')"
              width="full"
              color="primary"
            >
              Actualizar Keys
            </submitButton>
          </div>
          <div class="pb-6">
            <submitButton
              @do-click="change('BudaLogoutForm')"
              width="full"
              color="primary"
            >
              Desconectar Buda
            </submitButton>
          </div>
        </div>
      </div>
    </center>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import submitButton from '../SubmitButton';
import textField from '../TextField';

export default {
  name: 'BudaIndex',
  data() {
    return {
      routeName: 'budaIndex',
      api_key: '',
      api_secret: '',
      password: '',
    };
  },
  components: {
    submitButton,
    textField,
  },
  methods: {
    ...mapActions('component', ['changeBudaComp']),
    change(form) {
      this.changeBudaComp(form);
    },
  },
};
</script>
