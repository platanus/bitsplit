<template>
  <div
    class="items-center h-screen w-2/3 m-auto bg-primary p-12 mt-24 text-center"
  >
    <text-field font-size="full">
      ¿Olvidaste tu contraseña?
    </text-field>
    <form
      @submit.prevent="handleSubmit"
      class="bg-primary rounded pt-6 pb-8 mb-4"
    >
      <div class="mb-4">
        <inputLabel
          >Ingresa tu correo aqui y enviaremos un link para cambiar tu
          contraseña</inputLabel
        >
        <textInput
          field-id="email"
          field-type="text"
          field-placeholder="Correo"
          field-name="email"
          v-model="email"
        />
      </div>
      <submitButton :loading="signInLoading" width="full">
        Ingresar
      </submitButton>
    </form>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import textInput from '../components/Input';
import textField from '../components/TextField';
import submitButton from '../components/SubmitButton';
import inputLabel from '../components/InputLabel';

export default {
  name: 'Recover',
  data() {
    return {
      email: '',
    };
  },
  components: {
    textField,
    textInput,
    submitButton,
    inputLabel,
  },
  methods: {
    ...mapActions('user', ['sendRecoveryEmail']),
    handleSubmit() {
      const { email } = this;
      if (email) {
        this.sendRecoveryEmail({ email }).then(() => {
          this.$router.push('/');
        });
      }
    },
  },
};
</script>

<style lang="scss"></style>
