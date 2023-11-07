
class Villano{
    var property minions = []

    
    method nuevoMinion(){
       const unNuevoAyudante =new Minion{bananas = 5, armas = new Arma {nombre = "Rayo Congelador", potencia = 10}}
       minions.add(unNuevoAyudante)
    }

    method otorgarArma(unMinion,unArma){
        unMinion.meDieronArma(unArma)
    }

    method alimentar(unMinion,cantidadDeBananas){
        unMinion.comer(cantidadDeBananas)
    }

    method nivelDeConcentracion(unMinion){
        return unMinion.nivelDeConcentracion()
    }

    method planificarMaldad(){
        const minionsCapacitados = self.minionsCapacitados(unaMaldad)
        if(minionsCapacitados.length() == 0){
            self.error("No hay Minions capacitados")
        }
        minionsCapacitados.forEach{unMinion => unMinion.participarEnMaldad(unaMaldad)}
        unaMaldad.minionsEnLaMaldad(minionsCapacitados)
    }

    method minionsCapacitados(unaMaldad){
        return minions.filter{unMinion => unaMaldad.requerimientos(unMinion)}
    }

    method minionMasUtil(){
        return minions.max{unMinion => unMinion.maldadesHechas()}
    }

    method minionsInutiles(){
        return minions.filter{unMinion => unMinion.soyInutil()}
    }

}

//--------------------------------------------------------------------------------
//------------------------------------MALDADES------------------------------------
//--------------------------------------------------------------------------------

class Congelar{
    var property minionsEnLaMaldad

    method requerimientos(unMinion){
        return unMinion.tengoArma(rayoCongelante) && self.nivelDeConcentracionPedido(500, unMinion)
    }

    method nivelDeConcentracionPedido(valor, unMinion){
        return unMinion.nivelDeConcentracion() >= valor
    }

    method efectos(unMinion){
        ciudad.disminuirGrados(30)
        minionsEnLaMaldad.forEach{unMinion => unMinion.comer(10)}
    }
}

class Robar {
    const property objetoRobado 

    method requerimientos(unMinion){
        return unMinion.esPeligroso() && objetoRobado.requerimientos()
    }


    method efectos(unMinion){
        objetoRobado.premio(unMinion)
    }
}

object ciudad{
    var property grados
    var property cosasQueTengo = [luna, piramides, sueroMutante]

    method disminuirGrados(valor){
        grados -= valor 
    }
}

const rayoParaEncoger = new Arma (nombre = "rayo para encoger", potencia = 10)

object luna{

    method premio(unMinion)         = unMinion.meDieronArma(rayoParaEncoger) 
    method requerimientos(unMinion) = return unMinion.tengoArma(rayoParaEncoger)
}

object sueroMutante{

    method premio(unMinion)         = unMinion.tomarSuero(violeta)
    method requerimientos(unMinion) = return unMinion.bienAlimentado(100) && unMinion.nivelDeConcentracion() >= 23
}

object piramides{
    const property altura 

    method premio(unMinion)         = unMinion.comer(2)
    method requerimientos(unMinion) = return unMinion.nivelDeConcentracion() > altura /2
}


//--------------------------------------------------------------------------------
//------------------------------------MINIONS-------------------------------------
//--------------------------------------------------------------------------------

class Minion{
    var property armas = []
    var property color 
    var property maldadesHechas = 0
    var property bananas

    method meDieronArma(unArma){
        armas.add(unArma)
    }

    method comer(nuevasBananas){
        bananas += nuevasBananas
    }

    method nivelDeConcentracion(){
        const potenciaDelArma =  self.potenciaArmaMasPotente()
        return color.nivelDeConcentracion(potenciaDelArma, bananas)
    }

    method potenciaArmaMasPotente(){
        armas.max{unArma => unArma.potencia()}
    }

    method esPeligroso(){
        return color.esPeligrosoUnMinion(armas.size())
    }

    method tomarSuero(unColor){
        unColor.cambiarColor(self)
    }

    method participarEnMaldad(){
        maldadesHechas += 1
    }

    method bienAlimentado(valor){
        bananas > valor
    }

    method tengoArma(unArma){
        return armas.contains(unArma)
    }

    method soyInutil() = return maldadesHechas == 0
}

object amarillo{

    method esPeligrosoUnMinion(cantidadDeArmas){
        return cantidadDeArmas > 2
    }

    method nivelDeConcentracion(potenciaDelArma, bananas){
        return potenciaDelArma * bananas
    }

    method cambiarColor(unMinion){
        unMinion.comer(-1)
        unMinion.perderArmas()
        unMinion.color(violeta)
    }
}

object violeta{

    method esPeligrosoUnMinion(cantidadDeArmas) = true

    method nivelDeConcentracion(potenciaDelArma, bananas){
        return bananas
    }

    method cambiarColor(unMinion){
         unMinion.comer(-1)
         unMinion.color(amarillo)
    }
}

//--------------------------------------------------------------------------------
//------------------------------------ARMA----------------------------------------
//--------------------------------------------------------------------------------


class Arma{
    const property nombre
    const property potencia 
}

/*
El nivel de concentración de los minions se calcula como la potencia de su arma 
más potente más su cantidad de bananas, en el caso de los amarillos. En los violetas, 
equivale sencillamente a su cantidad de bananas, aunque tengan armas. */
