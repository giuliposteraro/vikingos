class Vikingo{
	var property castaSocial
	var property armas = 0
	method puedeIrAExpedicion(expedicion){
		if (not self.estaListo()){
			error.throwWithMessage("No puede subir a la expedicion")
		}
		self.realizarExpedicion(expedicion)
	}
	method realizarExpedicion(expedicion){
		expedicion.invadir()
	}
	method estaListo(){
		return self.esProductivo() and castaSocial.puedeSubir(self)
	}
	method esProductivo()
	// rol.soyProductivo()
	method cambiarCasta(nueva){
		castaSocial = nueva
	}
	method ascender(){
		castaSocial = castaSocial.ascender()
	}
}

object esclavo{
	method puedeSubir(vikingo){
	  	return vikingo.armas().size() > 1
	}
	
	method ascender(){
		return medio
	}
	
}

object medio{
	method puedeSubir(vikingo){
		return true
	}
	method ascender(){
		return noble
	}
}

object noble{
	method puedeSubir(vikingo){
		return true
	}
	method ascender(){
		return false
	}
}

class Soldado inherits Vikingo{
	var property vidas = 20
	override method esProductivo(){
		return vidas > 20 and self.tieneArmas()
	}
	method tieneArmas(){
		return armas != 0
	}
	override method ascender(){
		super()
		armas += 10
	}
}

class Granjero inherits Vikingo{
	var cantHijos = 10
	var hectareas = 4
	override method esProductivo(){
		return (hectareas / cantHijos) > 2
	}
	override method ascender(){
		super()
		cantHijos += 2
		hectareas += 2
	}
}

class Expedicion{
	var property vikingos = []
	var lugares = []
	method agregarLugar(cual){
		lugares.add(cual)
	}
	method agregarVikingo(quien){
		vikingos.add(quien)
	}
	method valenLaPena(){
		return lugares.all{lugar => lugar.valeLaPena(self)}
	}
	method botinTotal(){
		return lugares.sum{botin => botin.botinPorLugar()}
	}
	method invadir(){
		lugares.forEach{lugar => lugar.invadirse()} 
		self.dividirBotin()
	}
	method botinPorLugar(){
		return lugares.forEach{lugar => lugar.botinConseguido()}
	}
	method dividirBotin(){
		return self.botinTotal() / vikingos.size()
	}
}

class Capital{ // defensor.min(vikingo)
	var property defensores
	var factorRiqueza 
	method botinConseguido(){
		return defensores + factorRiqueza
	}
	method invadirse(){
		self.tomarVida() 
	}
	method tomarVida(){
		defensores = 0
	}
	method valeLaPena(expedicion){
		return self.botinConseguido() / expedicion.vikingos().size() >= 3
	}
}

class Aldea{
	var property botin
	var property cantCrucifijos
	method valeLaPena(expedicion){
		return self.botinConseguido() > 15
	}
	method botinConseguido(){
		return cantCrucifijos 
	}
	method invadirse(){
		return true
	}
}

class Amurallada inherits Aldea{
	override method valeLaPena(expedicion){
		return super(expedicion) and expedicion.cantVikingos() > 0
	}
}