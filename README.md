# Android Builds
> Репозиторий содержит конфигурации и параметры сборки, общие для всех android-проектов.
  
Файлы:

* [production.jks](#markdown-header-productionjks)        - *ключи подписи*
* [gradle.properties](#markdown-header-gradleproperties)  - *свойства сборки*
* [build.gradle](#markdown-header-buildgradle)            - *настройки сборки*
* [commit-msg](#markdown-header-commit-msg)               - *git-хук для коммитов*
* [README.md](#markdown-header-readmemd)                  - *справка* 
* [LICENSE](#markdown-header-license)                     - *лицензия*

------------------------------------------------------------



## [production.jks](./production.jks)
Стандартный Java Keystore файл.  
Содержит ключи подписи для всех публикуемых в Google Play проектов.  

> Так же содержит универсальный ключ **dev** для подписи по-умолчанию.  
Это может быть использовано для проектов, ещё не существующих на  
Google Play, библиотек, и прочих ситуаций когда необходимо отладить  
release-сборку проекта (корректность multi-dex, proguard-оптимизации и т.д.)
  
При создании нового ключа подписи рекомендуется придерживаться  
следующего формата:

* _alias_ - абсолютно идентичен (символ-в-символ) 
 [Application ID](https://developer.android.com/studio/build/application-id.html "Set the Application ID")  
* _password_ - восьми-символьный пароль, который включает латинские буквы  
(большие и маленькие) и цифры.  


## [gradle.properties](./gradle.properties)
Gradle-совместимый файл свойств.  
Содержит все необходимые свойства как для gradle-системы сборки, так и общие  
свойства, необходимые для сборочных скриптов, CI-систем и т.д. (например,  
текущие версии _android-sdk_, _build-tools_, _cmake_, etc...)


## [build.gradle](./build.gradle)
Gradle-совместимый файл настроек.  
Определяет дополнительные _runtime_ настройки, свойства и скрипты,  
зачастую то, что невозможно жёстко прописать в [gradle.properties](#gradle-properties).  
Например, если необходимо вычислить относительные пути, использовать  
переменные окружения и т.п. Также переопределяет версии наиболее популярных  
библиотек-зависимостей, например _andoid-support_, _play-services_ и т.д.


## [commit-msg](./commit-msg)
Bash-совместимый файл git-хук.  
Определяет логику подмены сообщений коммитов.  
Это по большее мере необходимо для корректной работы CI и позволяет определять  
коммиты, подлежащие запуску сборки и не подлежащие. 
 
При создании очередного комментария рекомендуется придерживаться следующего формата:
  
* ```X.X.X.XXX <commit message>``` - где:  
**```X.X.X```** - имя версии, **```XXX```** - код версии, **```<commit message>```** - сообщение коммита.  
*Таким образом CI будет понимать, что необходимо запустить сборку и использовать  
указанные значения версий, в том числе и для создания git-тэгов*
* ```<commit message>``` - где: **```<commit message>```** - сообщение коммита.  
*Такое сообщение будет автоматически преобразовано в ```[ci skip] <commit message>```,  
что указывает на необходимость пропустить текущую сборку,  
иначе говоря - игнорировать коммит*.

> Следует отметить, что зачастую build-сервер уведомляется по факту push-а на удалённый  
git-server. Соответственно, один push может быть получен сразу с несколькими commits.  
В любом случае, CI будет проверять будет последний по времени коммит и, на основании его  
*message*, либо запускать сборку (```X.X.X.XXX <commit message>```), либо её  
игнорировать (```[ci skip] <commit message>```).


## [README.md](./README.md)
Эта страница справки

## [LICENSE](./LICENSE)
```
MIT License

Copyright (c) 2017 Gleb Nikitenko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```