<template>
  <div class="flex flex-col justify-between flex-grow">
    <label
      class="txt-field block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2"
      for="grid-last-name"
    >
      Ingresa tu nombre
    </label>
    <textInput
      field-id="name"
      field-type="text"
      field-name="name"
      :value="name"
      v-model="name"
    />
    <label
      class="txt-field block uppercase tracking-wide text-gray-700 text-xs font-bold my-2"
      for="grid-last-name"
    >
      Ingresa tu Apellido
    </label>
    <textInput
      field-id="lastName"
      field-type="text"
      field-name="lastName"
      :value="lastName"
      v-model="lastName"
    /><label
      class="txt-field block uppercase tracking-wide text-gray-700 text-xs font-bold mt-4"
      for="grid-last-name"
    >
      Agrega tu foto de perfil
    </label>
    <textInput
      field-id="photo"
      field-type="text"
      field-name="photo"
      :value="photo"
      v-model="photo"
    /><label
      class="txt-field text-center block uppercase tracking-wide text-gray-700 text-xs font-bold mt-4"
      for="grid-last-name"
    >
      Selecciona tu fecha de nacimiento
    </label>
    <DatePicker
      class="mb-6 mt-2"
      min="1930"
      max="2021"
      v-model="selectedDate"
    />
    <SubmitButton @do-click="openSplitwiseUrl()">
      Agregar Información
    </SubmitButton>

    <p>El mensaje es: {{ selectedDate }}{{ name }}</p>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import SubmitButton from '../components/SubmitButton';
import DatePicker from '../components/DatePicker';
import textInput from '../components/Input';

export default {
  name: 'SplitwiseOnBoarding',
  data() {
    return {
      selectedDate: '',
      name: '',
      lastName: '',
      photo: '',
    };
  },
  components: {
    textInput,
    SubmitButton,
    DatePicker,
  },
  methods: {
    ...mapActions('user', ['signOut', 'getSplitwiseUrl']),
    openSplitwiseUrl() {
      this.getSplitwiseUrl()
        .then(res => {
          window.open(res.authorize_url);
          this.$router.push('/home');
        })
        .catch(err => {
          console.error(err);
        });
    },
  },
};
</script>
