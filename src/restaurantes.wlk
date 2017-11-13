object escuela {
	var profesores = []
	var estudiantes = []

	method esProfesor(alguien) 
		= profesores.contains(alguien)

	method agregarProfesor(alguien) {
		profesores.add(alguien)
	} 

	method agregarEstudiante(alguien) {
		estudiantes.add(alguien)
	}

	method recategorizar() {
		estudiantes.forEach{e=>e.recategorizar()}
	}
}

class Estudiante{
	var salioDeGira = false
	var dinero
	var platos
	var categoria = principiante
	constructor(_dinero, _platos){
		dinero = _dinero
		platos = _platos
	}
	method puedeSalir(costo) 
		= dinero >= costo and self.buenaOnda()
	
	method buenaOnda()

	method dinero() = dinero
	method salioDeGira() = salioDeGira
	method salirDeGira() {salioDeGira = true}
	method comer(){
		platos+=1
	}
	method pagar(importe){
		dinero -= importe
	}
	method categoria() = categoria
	method categoria(_categoria){ categoria = _categoria}
	
	method recategorizar(){
		if(categoria.puedeAscender(self))
			categoria.ascenderA(self)
	}
}

class Deglutidor inherits Estudiante{
	var auto 
	constructor(dinero, platos,_auto)
		= super(dinero, platos){
			auto = _auto
	}
	override method buenaOnda() = auto and platos>20
	
	method premioClasico(){
		platos += 3
	}
	
}

class Critico inherits Estudiante{
	var horasTele
	constructor(dinero, platos, _horasTele)
		= super(dinero,platos){
			horasTele = _horasTele
	}
	override method buenaOnda() = horasTele >= 10*platos 

	method premioClasico(){
		horasTele *= 1.1
	}
	method horasTele() = horasTele
	
}

class Gira{
	var casasDeComidas = []
	var personas = []
	var costoEstimado 
	
	constructor(costo){costoEstimado = costo}
	
	method personas() = personas
	
	method agregarLugar(lugar){
		casasDeComidas.add(lugar)
	}
	method valeLaPena()
		= casasDeComidas.all{casa=>
			casa.valeLaPena(self.cantidadPersonas())}
			
	method sumarA(persona){
		if (!persona.puedeSalir(costoEstimado))
			throw noPuedeIrDeGira 
		personas.add(persona)
	}
	method realizar(){
		personas.forEach{p=>p.salirDeGira()}
		casasDeComidas.forEach{casa=>self.comerEn(casa)}
	}
	method comerEn(casa) {
		var importe = casa.costoPorPersona(self.cantidadPersonas())
		personas.forEach{p=>
			p.comer() 
			p.pagar(importe)
		}	
	} 
			
	method cantidadPersonas() = personas.size()
}

class CasaDeComidas{
	var carta 
	constructor(platos){carta = platos}

	method costoPorPersona(cantidad)
		= carta.take(cantidad).sum{p=>p.costo()} / cantidad
}

class Restaurante inherits CasaDeComidas{
	var tenedores
	var chef
	constructor(platos, _tenedores, _chef) = super(platos){
		tenedores = _tenedores
		chef = _chef
	}
	method valeLaPena(_)
		= tenedores >=3 and chef.famosoOProfesor()
}

class RestauranteEtnico inherits Restaurante{
	var lugar
	constructor(platos, tenedores, chef, _lugar)
		= super(platos, tenedores, chef){
			lugar = _lugar
	}
	override method valeLaPena(_)
		= super(_) or lugar.exotico()
}

class Bodegon inherits CasaDeComidas{
	method valeLaPena(cantidadPersonas)
		= carta.size() >= cantidadPersonas
}

class Chef{
	var famoso = true

	method cambiarFama() {famoso = !famoso} 
	
	method famosoOProfesor() 
		= famoso or escuela.esProfesor(self)
}

class Lugar{
	var exotico 
	constructor(_exotico){
		exotico = _exotico
	}
	method exotico() = exotico
}

class Plato{
	var nombre
	var costo
	constructor(_nombre,_costo){
		nombre = _nombre
		costo = _costo
	}
	method costo() = costo
}

object principiante{
 	method puedeAscender(persona)
 		= persona.salioDeGira()
 	
 	method ascenderA(persona){	
		persona.categoria(clasico)
		persona.premioClasico()
	}
}

object clasico{
 	method puedeAscender(persona)
 		= persona.buenaOnda()
 	
 	method ascenderA(persona){	
		persona.categoria(experto)
	}
}

object experto{
 	method puedeAscender(persona) = false
}


object noPuedeIrDeGira inherits Exception{}

