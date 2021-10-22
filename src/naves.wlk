class Nave {
	var velocidad = 0
	var direccion = 0
	var combustible = 0
	method acelerar(cuanto){
		velocidad = (velocidad + cuanto).min(100000)
	}
	method desacelerar(cuanto){
		velocidad = (velocidad - cuanto).max(0)
	}
	method irHaciaElSol(){
		 direccion = 10
	}
	method escaparDelSol(){
		direccion = -10
	}
	method ponerseParaleloAlSol(){
		direccion = 0
	}
	method acercarseUnPocoAlSol(){
		direccion = (direccion++).min(10)
	}
	method alejarseUnPocoDelSol(){
		direccion = (direccion--).max(-10)
	}
	method cargarCombustible(litros){
		combustible += litros
	}
	method descargarCombustible(litros){
		combustible = (combustible - litros).max(0)
	}
	method preparaViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method estaTranquila() = combustible >= 4000 and velocidad <= 12000
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method escapar()
	method avisar()
	method estaDeRelajo(){
		return self.estaTranquila() and self.pocaActividad()
	}
	method pocaActividad()
}

class NaveBaliza inherits Nave{
	var color = "verde"
	var cantDeBalizasCambiadas = 0
	method cambiarColorDeBaliza(colorNuevo){
		color = colorNuevo
		cantDeBalizasCambiadas += 1
	}
	method prepararViaje(){
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	override method estaTranquila() = super() and color != "rojo"
	override method escapar() {self.irHaciaElSol()}
	override method avisar() {self.cambiarColorDeBaliza("rojo")}
	override method pocaActividad() = cantDeBalizasCambiadas == 0
}

class NavePasajeros inherits Nave{
	var property cantPasajeros = 0
	var property racionesComidas = 0
	var property racionesBebidas = 0
	var racionesComidaServidas = 0
	method cargarBebida(num){
		racionesBebidas += num
	}
	method descargarBebida(num){
		racionesBebidas = (racionesBebidas - num).max(0)
	}
	method cargarComida(num){
		racionesComidas += num
	}
	method descargarComida(num){
		racionesComidas = (racionesComidas - num).max(0)
		racionesComidaServidas += 1
	}
	method prepararViaje(){
		self.cargarBebida(cantPasajeros*6)
		self.cargarComida(cantPasajeros*4)
		self.alejarseUnPocoDelSol()
	}
	override method escapar() {velocidad *= 2} 
	override method avisar() {
		self.descargarComida(cantPasajeros)
		self.descargarBebida(2 * cantPasajeros )
	}
	override method pocaActividad() = racionesComidaServidas >= 50
}

class NaveCombate inherits Nave{
	var estaInvisible = false
	var misilesDesplegados = false
	var mensajesEmitidos = []
	method ponerseVisible() {estaInvisible = false}
	method ponerseInvisible(){estaInvisible = true}
	method estaInvisible() = estaInvisible
	method desplegarMisiles() {misilesDesplegados = true}
	method replegarMisiles(){misilesDesplegados = false}
	method misilesDesplegados() = misilesDesplegados
	method emitirMensaje(mensaje) {mensajesEmitidos.add(mensaje)}
	method mensajesEmitidos() = mensajesEmitidos
	method primerMensajeEmitido() = mensajesEmitidos.first()
	method ultimoMensajeEmitido() = mensajesEmitidos.last()
	method esEscueta() = mensajesEmitidos.any{send => send.size() < 30}
	method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)
	method prepararViaje(){
		self.ponerseVisible()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	override method preparaViaje(){
		super()
		self.acelerar(15000)
	}
	override method estaTranquila() = super() and !misilesDesplegados
	override method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	} 
	override method avisar() {self.emitirMensaje("Amenaza recibida")}
	override method pocaActividad() = self.esEscueta()
}

class NaveCombateSigilosa inherits NaveCombate{
	override method estaTranquila() = super() and !estaInvisible
	override method recibirAmenaza(){
		super()
		misilesDesplegados = true
		estaInvisible = true
	}
}

class NaveHospital inherits NavePasajeros{
	var property quirofano = false
	override method estaTranquila() = super() and !quirofano
	override method recibirAmenaza(){
		super()
		quirofano = true
	}
}