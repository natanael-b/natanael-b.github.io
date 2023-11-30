---
title: Natanael Barbosa Santos - Sobre o tal ano do Linux
---

<p align="right"><a href="/">Início</a> | <a href="/recents">Recentes</a> | <a href="/categories">Categoriass</a></p>

# Sobre o tal ano do Linux

Durante anos imperou uma esperança do mundo Linux sobre o "ano do Linux", isso já tem mais de 20 anos! Porém, como tudo que é antigo e eventualmente vira meme, o sentido original se perdeu ao longo do tempo. Então, resolvi escrever este artigo para tentar resgatar o que é o "ano do Linux", responder se é mensurável, se é importante e, principalmente, o principal (aqui, opinião minha) do porquê, em 23 anos, ele estar tão perto de chegar como nos anos 2000.

# A origem do "meme"

Quando o Linux surgiu, ele era basicamente terminal, fora pesquisadores de ciência da computação, ninguém dava muita bola. Até que uma empresa chamada SCO UnixWare resolveu competir diretamente com a Microsoft e Apple usando um projeto similar. Não é oficial a inspiração, mas curiosamente, 1 ano depois, surge a RHEL com o mesmo propósito. No entanto, havia um porém: como escrever softwares para Linux?

## DOS x UNIX

Embora tenha existido uma briga real entre os dois modelos, o que importa aqui é a divergência na forma de distribuir o software. Em 1999, no modelo DOS, você tem um arquivo fechado (que pode ser .EXE ou .COM) que contém tudo (ou quase tudo, o resto ficava na pasta do próprio programa) que o programa precisa para funcionar. Já no Unix, é consideravelmente diferente. O programa é segmentado em vários pedaços, e cada um deles é alocado em um lugar:

- `/opt/meu-programa` # onde ficam os programas de terceiros
- `/etc` # as configurações globais
- `/usr` # os programas do sistema
- `/usr/local` # os programas do sistema que o usuário instalou

Notou a falta de algo? Pois é, enquanto o DOS tinha ícones e lançadores já no próprio executável, o UNIX simplesmente não tinha isso em lugar nenhum. Então, cada sistema UNIX-like fazia do seu jeito, e isso, é claro, valia para os sistemas Linux.

## Resolvendo o problema

Não demorou muito (mas o suficiente para perder a primeira corrida) para a comunidade Linux perceber que brigar entre si mais atrapalhava do que ajudava. Então, em março de 2000, surge o FreeDesktop. A ideia aqui era padronizar o máximo possível, seja por ícones, seja por lançadores, seja onde e como colocar as coisas do usuário. E aí nasce o "meme" do ano do Linux. Não existem registros do motivo, mas pessoalmente, acredito que é porque, pela primeira vez, centenas de desenvolvedores que antes competiam entre si se juntaram para fazer algo crescer. Então, finalmente, as coisas caminhavam para se ter um real desafiante da hegemonia Apple x Microsoft. No entanto, apesar do avanço, mais problemas apareceram.

## A guerra dos formatos

Apesar de terem resolvido um problema enorme, ainda faltava o "chefão final": a forma de distribuir softwares. Enquanto no Windows e Mac estava cada vez mais fácil, no Linux estava bem caótico. Primeiro, porque os softwares de terceiros se misturavam com os do sistema. Segundo, porque softwares de terceiros frequentemente quebravam API e ABI. Então, o mundo se dividiu em dois: o Debian e RHEL. Existiam n formatos, mas de longe esses foram os maiores expoentes.

### As primeiras soluções

Assim como aconteceu com a localização dos arquivos-chave, a comunidade se reuniu novamente para resolver esse problema. Nesse meio, existem 2 soluções que merecem destaque:

- **SuperDebs**: de origem mista, porém com forte influência brasileira, ele funcionava de maneira peculiar. Basicamente, listava os pacotes que vinham com Debian desktop e, dessa lista, tiravam pacotes de aplicativos e do desktop. Feito isso, para fazer o "SuperDeb", ele incluía todas as dependências em pacotes Debian individuais do pacote, exceto os da lista, e disparava um `apt install` nas dependências faltando.

- **klik**: Esse é o avô dos AppImages, bisavô dos Flatpaks e tataravô dos Snaps. Se os SuperDebs só funcionavam no Debian e no recém-nascido Ubuntu, o `klik` resolveu isso encapsulando um ambiente `chroot` inteiro no pacote. Agora, essencialmente, funcionava em todas as distros que tinham um kernel recente.

Mas dessa vez não foi tão pacífico, e pela primeira vez a briga não era entre devs, mas entre a comunidade de usuários... O que aconteceu foi que, de um lado, surgiram os que atacavam essas tentativas, dizendo que "compilar era melhor", e os que endeusavam uma solução e demonizavam a outra.

Nesse ponto da história, estamos em 2010.

# A grande quebra de API

Se você perguntar para um programador Linux dessa época algum evento traumático, sem dúvidas, muitos deles responderiam: GTK 3 e Python 3 (curiosamente a versão 3 de ambos). O que aconteceu foi que centenas de milhares de projetos extremamente complexos, como ambientes desktops inteiros, tiveram seu código transformado em lixo. Esse evento foi tão traumático que iniciou uma migração maciça de projetos de GTK para Qt. Blogs na época chamaram o evento de "a grande migração para Qt" e resultou no líder e criador da linguagem Python prometendo que nunca mais faria algo assim. O custo foi milhares de projetos simplesmente deixando de existir e outros, até hoje, em fase de migração como o GIMP.

# Steve Jobs e o Ubuntu

Voltando em 2007, era lançado o iPhone. Mas além do smartphone da Apple, um conceito totalmente novo: webapps. Até então, os aplicativos eram apenas nativos. Isso significa que o desenvolvedor tinha que fazer um executável para cada plataforma. Mas isso mudou. Apple e Google trabalharam juntas para desenvolver mecanismos de rodar esses aplicativos no navegador, qualquer navegador... E de volta para o futuro em 2014, a Canonical entra na jogada com o SDK semi-nativo. A ideia é ter um app feito com tecnologias web, mas rodando offline e com acesso aos recursos do sistema (te lembra algo?). Porém, mais uma vez, o clubismo venceu, e a Canonical foi duramente atacada até simplesmente desistir do projeto, sendo o primeiro prego no caixão do Ubuntu Touch, que dependia desse SDK. Mas o que mais foi perdido foi a integração com os WebApps existentes (o "Abrir como janela do Chrome").

# Compatibilidade com Windows

Estamos em 2016, e o único grande avanço que a comunidade teve que não causou traumas ou rachas foi o FreeDesktop. Pois é, perdemos a guerra pelo desktop, pelo mobile e pelo Web, mas algo vai melhorar: o Wine. De início, não parece fazer sentido citar o Wine só aqui (afinal, ele existe desde 2002), mas foi nesse ano que o desenvolvimento acelerado começou. Cada dia, o Staging recebia um suporte cada vez mais aperfeiçoado. Isso é muito emocionante, mas o que realmente importa é que nada aconteceu. Wine lá e distros cá, isso viria a ser um pouquinho diferente em 2018 com o lançamento do Proton pela Valve. Pela primeira vez, alguém de abrangência estava vendo o potencial do Wine.

# A pandemia

Estamos agora em 2020, e daqui pra frente nada de relevante no Desktop Linux acontece (calma que eu justifico). O ponto aqui é que seria o momento perfeito para mostrar como os sistemas Linux eram ideais para a situação, seja em faculdades, seja em escolas e até em casa, por N motivos... Perdemos mais uma oportunidade.

# O que esperar do tal ano do desktop?

Imagino que a única forma de responder é resgatar o meme antigo. Vai ser um ano onde a comunidade se una para implementar no desktop o que falta:

| Recurso                                     | Descrição                                                                                           |
|---------------------------------------------|-------------------------------------------------------------------------------------------------------|
| Suporte universal a aplicações híbridas      | Eu, como desenvolvedor web, adiciono umas tags no meu site, empacoto um arquivo e o usuário baixa. Dá dois cliques, e meu Web App tem integração nativa como o player na barra de notificações, como acontece com Android. Melhora se tiver uma loja para publicar. |
| Integração com Wine                         | Eu, como usuário, baixo um .exe que o Wine suporta, um protocolo universal em todas as distros, como acontece com o XDG. Pré-configura um prefixo Wine para que o aplicativo possa ser instalado sem dificuldade. |
| Formato executável                          | Eu, como usuário, baixo um executável, dou 2 cliques e rodo o programa, com opção de instalar ou não.  |
| Instalador online                           | Eu, como usuário, baixo um arquivo, dou 2 cliques de uma loja, meu programa é baixado e instalado.  |
| Marketing massivo em prol de algo em comum  | É algo autoexplicativo, um exemplo do que não fazer: o @Daigo fez uma petição destinada a fabricantes de hardware para enviarem uma distro Linux (o Tiger OS no caso) que não seja feita apenas para baratear custos. O que foi que aconteceu? Cada um pegou a petição, trocou o nome Tiger OS pela distro que usava, resultando em centenas de petições com poucos usuários assinando cada uma, milhares de assinaturas diluídas em centenas de distros, diluídas novamente em várias petições. Ou seja, algo com grande potencial virando nada por pura desunião. |
| Padrões como padrões                       | Por design, o Linux tem recursos que melhorariam e muito a usabilidade. No entanto, as distros fingem que não existem. Fontes, temas, configurações... |

As brigas e o fanatismo atrasam o Linux no desktop a 20 anos se perdeu 2 revoluções e estamos a ponto de perder a dos prompts de comando em linguagem natural pelo mesmo motivo, precisamos resgatar urgente o espirito do "ano do Linux" tudo de positivo veio desse meme mesmo que nos podcasts como o do @Diolinux ele seja tratado como algo banal, claro que diversidade é bom, não é a questão não é reduzir 700 distros pra 2 ou 3, e sim que as 700 distros trabalhem para que todas implementem pelo menos o básico, marketing massivo é caro e ineficaz, mas para uma pessoa só, se várias se juntarem o custo e até os esforços necessários são reduzidos... claro que quem vem do Linux está acostumado a baixar softwares da loja mas quem vem do Windows geralmente tem um pendrive com executáveis offline uma boa solução agrada os dois lados

# FAQ:

## Por que não citou X?
<small>(Coloque sua tecnologia favorita no lugar de X)</small>

Em um resumo muito grande: ou porque não estão completas, ou porque sofrem da guerra clubista, ou porque são tecnologias intangíveis ao usuário. Algumas, inclusive, pelos 3 motivos.

## Mas a distro X tem Y...
<small>(Coloque sua distro favorita no lugar de X e a tecnologia citada em Y)</small>

E o resto? Nenhum dos recursos é opcional.

## Mas Eu não uso X logo...
<small>(Coloque a tecnologia citada em X)</small>

Existem pelo menos 5,5 bilhões de outras pessoas que potencialmente usam ou até dependem de X. Se você não usa, precisa ou gosta: parabéns, agora veja as outras pessoas, elas podem usar e precisar (ou achar que precisam) de X.


-----------

