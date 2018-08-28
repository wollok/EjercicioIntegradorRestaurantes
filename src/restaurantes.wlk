
object escuela {
	var profesores = []
	var estudiantes = []

	method esProfesor(alguien) 
		= profesores.contains(alguien)

	method agregarProfesor(alguien)  {
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
	var property salioDeGira = false
	var property dinero
	var platos
	var property categoria = principiante

	method puedeSalir(costo) 
		= dinero >= costo and self.buenaOnda()
	
	method buenaOnda()

	method salirDeGira() {salioDeGira = true}
	method comer(){
		platos+=1
	}
	method pagar(importe){
		dinero -= importe
	}
	method recategorizar(){
		if(categoria.puedeAscender(self))
			categoria.ascenderA(self)
	}
}

class Deglutidor inherits Estudiante{
	var auto 

	override method buenaOnda() = auto and platos>20
	
	method premioClasico(){
		platos += 3
	}
	
}

class Critico inherits Estudiante{
	var property horasTele
	
	override method buenaOnda() = horasTele >= 10*platos 

	method premioClasico(){
		horasTele *= 1.1
	}

}

class Gira{
	var casasDeComidas = []
	var property personas = []
	var costoEstimado 
	
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
	
	method costoPorPersona(cantidad)
		= carta.take(cantidad).sum{p=>p.costo()} / cantidad
}

class Restaurante inherits CasaDeComidas{
	var tenedores
	var chef
	
	method valeLaPena(_)
		= tenedores >=3 and chef.famosoOProfesor()
}

class RestauranteEtnico inherits Restaurante{
	var lugar
	
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
	var property exotico 
	
}

class Plato{
	var property nombre
	var property costo
	
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

