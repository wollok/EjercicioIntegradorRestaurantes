object escuela {
	const profesores = []
	const estudiantes = []
	
	method esProfesor(alguien) = profesores.contains(alguien)
	
	method agregarProfesor(alguien) {
		profesores.add(alguien)
	}
	
	method agregarEstudiante(alguien) {
		estudiantes.add(alguien)
	}
	
	method recategorizar() {
		estudiantes.forEach({ e => e.recategorizar() })
	}
}

class Estudiante {
	var property salioDeGira = false
	var property dinero
	var platos
	var property categoria = principiante
	
	method puedeSalir(costo) = (dinero >= costo) and self.buenaOnda()
	
	method buenaOnda()
	
	method salirDeGira() {
		salioDeGira = true
	}
	
	method comer() {
		platos += 1
	}
	
	method pagar(importe) {
		dinero -= importe
	}
	
	method recategorizar() {
		if (categoria.puedeAscender(self)) categoria.ascenderA(self)
	}
}

class Deglutidor inherits Estudiante {
	const auto
	
	override method buenaOnda() = auto and (platos > 20)
	
	method premioClasico() {
		platos += 3
	}
}

class Critico inherits Estudiante {
	var property horasTele
	
	override method buenaOnda() = horasTele >= (10 * platos)
	
	method premioClasico() {
		horasTele *= 1.1
	}
}

class Gira {
	const casasDeComidas = []
	var property personas = []
	const costoEstimado
	
	method agregarLugar(lugar) {
		casasDeComidas.add(lugar)
	}
	
	method valeLaPena() = casasDeComidas.all(
		{ casa => casa.valeLaPena(self.cantidadPersonas()) }
	)
	
	method sumarA(persona) {
		if (!persona.puedeSalir(costoEstimado)) {
			throw new NoPuedeIrDeGira()
		}
		personas.add(persona)
	}
	
	method realizar() {
		personas.forEach({ persona => persona.salirDeGira() })
		casasDeComidas.forEach({ casa => self.comerEn(casa) })
	}
	
	method comerEn(casa) {
		const importe = casa.costoPorPersona(self.cantidadPersonas())
		personas.forEach({ persona =>	
			persona.comer()
			persona.pagar(importe)
		})
	}
	
	method cantidadPersonas() = personas.size()
}

class CasaDeComidas {
	const carta
	
	method costoPorPersona(cantidad) = carta.take(cantidad).sum(
		{ persona => persona.costo() }
	) / cantidad
}

class Restaurante inherits CasaDeComidas {
	const tenedores
	const chef
	
	method valeLaPena(_) = (tenedores >= 3) and chef.famosoOProfesor()
}

class RestauranteEtnico inherits Restaurante {
	const lugar
	
	override method valeLaPena(_) = super(_) or lugar.exotico()
}

class Bodegon inherits CasaDeComidas {
	method valeLaPena(cantidadPersonas) = carta.size() >= cantidadPersonas
}

class Chef {
	var famoso = true
	
	method cambiarFama() {
		famoso = !famoso
	}
	
	method famosoOProfesor() = famoso or escuela.esProfesor(self)
}

class Lugar {
	var property exotico = false
}

class Plato {
	var property nombre
	var property costo
}

object principiante {
	method puedeAscender(persona) = persona.salioDeGira()
	
	method ascenderA(persona) {
		persona.categoria(clasico)
		persona.premioClasico()
	}
}

object clasico {
	method puedeAscender(persona) = persona.buenaOnda()
	
	method ascenderA(persona) {
		persona.categoria(experto)
	}
}

object experto {
	method puedeAscender(persona) = false
}

class NoPuedeIrDeGira inherits Exception {
	
}