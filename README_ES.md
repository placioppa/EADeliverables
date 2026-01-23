| Autor | Fecha de Creación | Fecha de Edición | Versión |
| ------------- | ------------- | ------------- | ------------- |
| Pablo Lacioppa | 08-01-2026  | 23-01-2026 | 0.2 |

<br/>

## 1. INTRODUCCIÓN

El presente repositorio cuenta con una solución llamada EADeliverables, cuya estructura se basa principalmente en 3 hojas de cálculo del tipo “Excel con macros” distribuidas equitativamente en tres proyectos internos: _CoreDeliverables_, _OperationalDeliverables_ y _DecisionDeliverables_. Cada una se ubica dentro del directorio /Files de su proyecto de referencia y entre todas constituyen lo que conceptualmente he pasado a denominar: El Framework EA para pequeñas y medianas empresas. 

Por otro lado, el resto de los archivos existentes en cada uno de los módulos mencionados previamente, tienen como función reflejar las funcionalidades extendidas a través de las macros hacia las hojas de cálculo y permitir así una ágil visualización del código fuente utilizado. Los mismos no impactan sobre el funcionamiento real de la macro, sino que simplemente manifiestan una copia del código embebido dentro de cada archivo Excel, por lo que su eventual alteración no tendrá ningún efecto práctico en los resultados.

La solución cuenta además con un cuarto proyecto denominado EASummary, cuya función es la de albergar archivos auxiliares que asistan al usuario en el proceso de identificar y completar la información requerida por los tres módulos principales. Actualmente el único contenido disponible es un archivo llamado EASummary, cuyo uso vendrá considerado durante la ejecución del proceso.

En relación al proceso, el mismo refiere propiamente al mecanismo por el cual se utilizarán las tres hojas de cálculo ya mencionadas, para entender conceptualmente la estructura y funcionamiento de la empresa, como así también para identificar su problemática actual y los riesgos que afectarían el desarrollo futuro de sus objetivos.
Como resultado, se obtendrá suficiente información para diagnosticar:
 - Deficiencias 
 - Sobrecargas
 - Inconsistencias en la toma de decisiones
 - Falta de gobernabilidad
 - Desalineamientos entre cómo se plantea la estrategia del negocio y cómo se ejecuta
 - Superposición de roles y responsabilidades
 - Costos imprevistos
 - Falta de preparación para la incorporación de Inteligencia Artificial en los procesos de la empresa
 - Herramientas informáticas mal utilizadas
   
Es importante aclarar que el Framework no es una herramienta diseñada para producir un diagnóstico automático sobre los problemas o potenciales problemas que afecten a la empresa, sino que está orientado principalmente a relevar y señalar. La interpretación de los resultados, como así también la generación de propuestas concretas que permitan corregir el rumbo actual, quedan a cargo de cada arquitecto, gerente o director operativo que realice el seguimiento o establezca medidas sobre estas planillas.
Pese a que algunos módulos cuentan con leyendas e indicadores visuales que ayudan a efectuar un diagnóstico veloz y emprender la toma de decisiones, se recomienda hacer un análisis global y completo de la información relevada a la hora de optar por modificar componentes de la organización.

<br/>

## 2. PERSPECTIVA DEL PROYECTO

Para todos aquellos que estén familiarizados con conceptos generales de arquitectura de la empresa (algunos ya mencionados implícitamente al plantear los elementos comprendidos por el diagnóstico), TOGAF o método Zachman, habrán obtenido hasta aquí toda la información necesaria para iniciar a utilizar el framework – y los aliento a ello!.

Para aquellos otros que deseen entender un poco más en profundidad la composición interna de los módulos y la metodología de trabajo propuesta, describiré a continuación cuál es el enfoque o perspectiva sobre la que se posiciona la herramienta. Y es que si bien la misma cuenta con matices que bien podrían asociarse al método Zachman, como ser el planteamiento de los módulos basados en las preguntas clave: qué…?, por qué…?, y cómo…?, el corazón del proyecto está inspirado en el análisis realizado por Eric Jager en su libro _Getting Started with Enterprise Architecture_<sup>1</sup>.

El autor plantea de manera eficaz cómo aplicar TOGAF desde un punto de vista pragmático y enfocado a las necesidades fundamentales de una organización. Para quiénes no estén familiarizados con el término, TOGAF es un estándar<sup>2</sup>, y también una metodología, creada por The Open Group en 1995 con el fin de organizar el trabajo arquitectural de las grandes organizaciones. Actualmente muchas empresas importantes y agencias gubernamentales lo utilizan eficientemente y han logrado aumentar la robustez e interoperabilidad de sus procesos informáticos.

El presente framework adopta estos conceptos de manera flexible, sin apegarse a ellos en su totalidad. El objetivo es siempre el mismo: promover las herramientas para instalar en la organización las prácticas que representan a la arquitectura empresarial (EA) como disciplina de trabajo. Eric Jager logra construir este enfoque en su libro pero el mismo resulta aún un tanto difícil de implementar en el contexto de empresas pequeñas, o empresas medianas, donde no existe ningún indicio de voluntad de querer incorporar un proceso que genere “burocracia” sobre los mecanismos de toma de decisiones.
Es por ello que los tres módulos planteados para este proyecto cumplen con la premisa de simplificar y reducir al máximo la labor arquitectural inicial, dando la posibilidad de establecer los cimientos sobre los cuales construir un proceso mayor. Permitiendo luego que evolucione, conforme vaya evolucionando la empresa y promoviendo, además, el uso de un lenguaje común y la generación de documentos fundamentales para cumplir su misión.

<br/>

```
Referencias:

1. Jager, E. (2023). Getting Started with Enterprise Architecture: A Practical and Pragmatic Approach to Learning the Basics of Enterprise Architecture. Apress
2. The Open Group. (2022). The TOGAF® Standard, 10th Edition. Open Group.

```


## 3. ESTRUCTURA DE LOS MÓDULOS, ¿CUÁLES SON LOS DOCUMENTOS A COMPLETAR?

Como se mencionó anteriormente, el framework promueve el uso de tres documentos principales: Core Deliverables, Operational Deliverables y Decision Deliverables. Si bien los mismos pueden ser completados (en algunos casos) sin seguir un orden específico, la realidad es que el proceso invita a respetar el orden secuencial de los mismos: 

1. **Core Deliverables**: Documento del tipo estratégico orientado a indicar qué hace (o debería hacer) la empresa para funcionar. Constituye el primer entregable con información arquitectural que formaliza:
   - El mapa de la organización.
   - El mapa de roles y responsabilidades.
   - El catálogo de Capacidades de la empresa.
   - La evaluación de cuán preparada está la empresa para adoptar Inteligencia Artificial dentro de su operación.

2. **Operational Deliverables**: Documento del tipo práctico, orientado a ordenar cómo la empresa debe operar. Constituye el segundo entregable del proceso y comprende los siguientes elementos:
   - Mapa de las partes interesadas (Stakeholders).
   - Catálogo de aplicaciones utilizadas por la organización.
   - Catálogo de infraestructura tecnológica utilizada por la organización.
   - Inventario de procesos y su relación con las Capacidades de la empresa.

3. **Decision Deliverables**: Documento del tipo crítico, orientado a describir por qué la organización opera de la manera que lo hace. Constituye el tercer y último entregable del proceso, formalizando los siguientes elementos:
   - Principios básicos de la organización
   - Objetivos e iniciativas
   - Registro de decisiones Arquitecturales
   - Modelo de costos
   - Roadmap

Adicionalmente, cada documento cuenta con una pestaña inicial (0#) al interno, orientada especialmente a describir el propósito de cada elemento en cuestión, como así también las consideraciones a tener en cuenta para completarlo correctamente. 
Es recomendable, por sobretodo, evitar modificar las estructuras de las tablas, dado que las mismas se encuentran estrictamente ligadas a los comportamientos de las macros a través de rangos nomenclados (Formulas → Name manager). La cantidad de registros existentes dentro de cada una tiene, por un lado, el propósito de limitar la modalidad de carga de la información en un contexto de pequeñas y medianas organizaciones. Por otro lado, el hecho que el número máximo de registros no supere las dimensiones predeterminadas para un elemento específico, tiene que ver además con la naturaleza de la información que se está requiriendo. Por ejemplo, la cantidad de Principios básicos de la organización que deben ser cargados dentro del documento Decision Deliverables, no debe ser mayor a cinco porque así está contemplado en el propósito general de los principios. 


## 4. CONSIDERACIONES

 - Los documentos cuentan con datos ejemplificados y organizados de manera genérica para describir la totalidad del proceso. Durante la carga de los mismos, se recomienda eliminar toda información que no refleje el contexto real de la empresa.
 - Los elementos cargados en cada documento cuentan con un propósito asignado y una audiencia recomendada. En el caso que los roles sugeridos no se correspondan con el contexto empresarial mencionado, modificar las audiencias buscando los roles equivalentes que sí existan dentro de la empresa.
 - Existe una configuración de colores para indicar cuáles documentos, o partes del documento, deben ser completados y cuáles no: 
   - ![#1589F0](https://placehold.co/15x15/1589F0/1589F0.png) **Azul**: Completar siguiendo eventuales instrucciones aclaradas en la pestaña inicial (0#)
   - ![#b45f06](https://placehold.co/15x15/b45f06/b45f06.png) **Naranja**: No completar. La información será generada de manera automática.
   - ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) **Verde**: Completar siguiendo instrucciones con la información que ha sido exportada desde otro documento.
- Los documentos cuentan, como ya se ha mencionado, con macros embebidas dentro de las hojas de cálculo. Por motivos de seguridad, es probable que las mismas se encuentren inicialmente deshabilitadas y deban ser habilitadas.
  <img width="999" height="472" alt="image" src="https://github.com/user-attachments/assets/1f02bfcf-cfda-407a-8840-e65a9d768f10" />
- Habilitar también el contenido de las conexiones de datos realizadas a través de Power Query dentro de cada documento.
  <img width="531" height="44" alt="Screenshot 2026-01-09 145058" src="https://github.com/user-attachments/assets/d467921b-647f-49b0-a7cd-432445b0aa59" />


## 5. USO EN MICRO-EMPRESAS

La utilización del Framework en entornos compuestos por un grupo reducido de personas es no solo posible, sino también recomendable, por diversos motivos.
En primer lugar, es importante tener en cuenta que existe un conjunto de conocimientos básicos y esenciales que involucran a todos los actores, presentes y futuros, de una compañía. Considérese, por ejemplo, el mapa de partes interesadas (stakeholder map), cuyo objetivo es detallar quiénes son los individuos o grupos de individuos que influyen en proyectos, desarrollos y decisiones. Comprender el alcance que estos pueden tener dentro de la empresa es, por lo tanto, una meta que debería comprometer a todos por igual. En consecuencia, contar con esta información desde el primer día permite no solo comunicar de forma eficiente a los nuevos actores —reduciendo los tiempos del proceso de transferencia de conocimiento—, sino también identificar y comunicar con mayor eficacia a quienes tienen un impacto directo sobre la organización.

En segundo lugar, muchas empresas que buscan —y logran— crecer rápidamente se enfrentan a la compleja tarea de reorganizar sus estructuras internas, ya sea mediante la incorporación de nuevas unidades de negocio o de nuevos actores dentro de estas. Cuando esto ocurre, la naturaleza de la información tiende a fragmentarse, de modo que cada grupo o subgrupo de individuos —ya sea por experiencias profesionales previas o por desconocimiento— termina refiriéndose a los mismos conceptos de maneras distintas. Como consecuencia, se generan duplicaciones de información, procesos redundantes y una sobrecarga de tareas asociadas al alineamiento interno. La solución subyace a través del uso de un "lenguaje común", representado por los documentos que promueve este Framework.

Por último, y de igual forma relacionado con el punto anterior, el lenguaje utilizado en cada uno de los documentos que conforman la solución es, en mayor o menor medida, una representación simplificada de enfoques y soluciones más complejos, propios de contextos empresariales de gran escala, como es el caso del Framework TOGAF. Esto permite que, llegado el momento y de ser necesario, su adopción se realice de manera mucho más eficiente y transparente por contar ya con herramientas y conceptos propios de su estructura.

