﻿
//*****************************************************************************************************\\
// Copyright (©) Cergey Latchenko ( github.com/SunSerega | forum.mmcs.sfedu.ru/u/sun_serega )
// This code is distributed under the Unlicense
// For details see LICENSE file or this:
// https://github.com/SunSerega/POCGL/blob/master/LICENSE
//*****************************************************************************************************\\
// Copyright (©) Сергей Латченко ( github.com/SunSerega | forum.mmcs.sfedu.ru/u/sun_serega )
// Этот код распространяется под Unlicense
// Для деталей смотрите в файл LICENSE или это:
// https://github.com/SunSerega/POCGL/blob/master/LICENSE
//*****************************************************************************************************\\

///
///Выскокоуровневая оболочка для модуля OpenCL
///OpenCL и OpenCLABC можно использовать одновременно
///Но контактировать они практически не будут
///
///Если чего то не хватает - писать как и для модуля OpenCL, сюда:
///https://github.com/SunSerega/POCGL/issues
///
///Справка данного модуля находится в начале его исходника
///Исходники можно открывать Ctrl+кликая на любое имя из модуля (включая название модуля в "uses")
///
unit OpenCLABC;

{$region Подробное описание OpenCLABC (аля справка)}

{$region 1. Основные принципы}

{$region 1.0. Разное}

// 1.0.1
// 
// Для бОльших удобств чтения справки рекомендуется включить сворачивание кода
// Чтоб его включить:
// Сервис >> Настройки >> Редактор >> Разрешить сворачивание кода
// Когда эта опция включена - регионы можно сворачивать нажав на [-] слева
// Так же под ПКМ есть кнопка "Свернуть Все регионы"
// 

// 1.0.2
// 
// В следующих секциях есть упоминания примеров
// Эти примеры можно найти в папке "C:\PABCWork.NET\Samples\OpenCL\OpenCLABC\Из справки"
// А так же в соответствующей папке репозитория на гитхабе: "https://github.com/SunSerega/POCGL/tree/master/Samples/OpenCL/OpenCLABC/Из справки"
// 

// 1.0.3 - Термины, которые часто путают новички в программировании
// 
// Команда - запрос на выполнение чего-либо
//   Как запрос на запуск программы на GPU
//   Или запрос на начало чтения данных из буфера на GPU в оперативную память
//   Называть процедуры и функции командами - ошибочно
// 
// Подпрограмма - процедура или функция
// 
// Метод - особая подпрограмма, вызываемая в коде через переменную
//   К примеру, метод Context.SyncInvoke выглядит в коде как "cont.SyncInvoke(...)", где cont - переменная типа Context
// 
// Статичный метод - особая подпрограмма, вызываемая в коде через имя типа
//   К примеру, статичный метод Buffer.ValueQueue выглядит в коде как "Buffer.ValueQueue(...)"
// 
// Остальные термины (как свойства), которые будут непонятны - ищите в справке паскаля или интернете

{$endregion 1.0. Разное}

{$region 1.1 - Что такое OpenCLABC}

// 
// Выскокоуровневая оболочка для модуля OpenCL
// То есть, с OpenCLABC надо на много меньше кода для больших и сложных программ
// Но такой же уровень микроконтроля как с голым OpenCL - недоступен
// Напримеру, на прямую управлять эвентами невозможно
// Вместо этого надо использовать операции с очередями (как сложение и умножение очередей)
// 

{$endregion 1.1 - Что такое OpenCLABC}

{$region 1.2 - Контекст (Context)}

// 
// Для посылания команд для GPU необходим контекст (объект типа Context)
// Он содержит информацию о том, какое железо будет использоваться для выполнения программ и хранения содержимого буферов
// 

{$endregion 1.2 - Контекст (Context)}

{$region 1.3 - Очередь [команд] (CommandQueue)}

// 
// Передавать команды в OpenCL по 1 - не эффективно
// Правильно передавать сразу по несколько команд за раз
// Для этого и существуют очереди (типы, наследующие от "CommandQueue<T>")
// Они хранят любое кол-во команд для OpenCL
// И при необходимости - части кода на паскале (как с HFQ, HPQ), выполняемые на хосте (на CPU)
// 

{$endregion 1.3 - Очередь [команд] (CommandQueue)}

{$region 1.4 - Буфер (Buffer)}

// 
// Программы на GPU не могут пользоваться оперативной памятью (без определённых расширений)
// Поэтому для передачи данных в такую программу и чтения результата - надо выделять память на самом GPU
// 
// Данные о область памяти, выделенной на GPU
// А так же всевозможные операции с этой памятью
// Доступны через переменные типа Buffer
// 

{$endregion 1.4 - Буфер (Buffer)}

{$region 1.5 - Контейнер для кода (ProgramCode)}

// 
// Обычные программы невозможно запустить на GPU
// Специальные программы для GPU запускаемые через OpenCL - обычно пишутся на особом языке "OpenCL C" (который основан на языке "C")
// Его описание не является частью данной справки
// Максимум что вы можете найти тут - ссылку на 1 из последних версий его спецификации:
// https://www.khronos.org/registry/OpenCL/specs/2.2/pdf/OpenCL_C.pdf
// 
// Код на языке OpenCL-C храниться в объектах типа ProgramCode
// Объекты этого типа используются только как контейнеры
// 1 объект ProgramCode может содержать любое кол-во подпрограмм-карнелов
// 

{$endregion 1.5 - Контейнер для кода (ProgramCode)}

{$region 1.6 - Карнел (Kernel)}

// (вообще, по английски правильно кёрнел, но карн́ел легче произнести)
// 
// Объект типа Kernel представляет 1 подпрограмму-карнел
// Карнел хранит код, который можно выполнить на GPU
// 

{$endregion 1.6 - Карнел (Kernel)}

{$endregion 1. Основные принципы}

{$region 2. Контекст (Context)}

// 
// Создать контекст можно конструктором ("new Context")
// Можно так же не создавать контекст, а использовать всюду свойство Context.Default
// Изначально, этому свойству присваивается контекст, использующий 1 любой GPU (если такой есть)
// или 1 любой другой девайс, поддерживающий OpenCL (если GPU нету)
// 
// Кроме того, Context.Default можно перезаписывать
// Это удобно, если во всей программе вы будете использовать общий контекст
// Операции, у которых не указывается контекст - всегда используют Context.Default
// 
// Для вызова команд в определённом контексте - используется метод Context.BeginInvoke
// Он возвращает объект типа Task, через который можно наблюдать за выполнением и ожидать его окончания
// Так же есть метод Context.SyncInvoke, вызывающий .BeginInvoke и затем метод Task.Wait, на полученом объекте
// Подробнее в разделе 3.2
// 

{$endregion 2. Контекст (Context)}

{$region 3. Очередь [команд] (CommandQueue)}

{$region 3.0 - Возвращаемое значение очередей}

// 
// У каждого типа очереди есть свой тип возвращаемого значение
// К примеру, так объявляется переменная, в которую можно будет сохранить очередь, возвращающую "integer":
// var Q1: CommandQueue<integer>;
// 
// Очереди созданные из буфера или карнела - возващают свой буфер/карнел соответственно, из которых их создали
// Очереди созданные с HFQ - возвращают то значение, которое возвращала оригинальная функция
// Очереди созданные с HPQ - возвращают значение типа object (и всегда nil)
// 
// После выполнения очереди метод Context.SyncInvoke возвращает то, что вернула очередь
// А если использовать метод Context.BeginInvoke - возвращаемое значение можно получить через свойство Task.Result
// 

{$endregion 3.0 - Возвращаемое значение очередей}

{$region 3.1. Создание очередей}

// 3.1.1 - Создание очередей с командами для GPU
// 
// Самый просто способ создать очередь - выбрать объект (как, Kernel или Buffer)
// У которого есть что то, что можно выполнять на GPU (как выполнение карнела или запись/чтение содержимого буфера)
// И вызвать для него метод .NewQueue
// Подробнее в примере "3 - Очередь\Создание очереди из буфера.pas"
// 
// Полученная очередь будет иметь особый тип - KernelCommandQueue/BufferCommandQueue соответственно
// К такой очереди можно добавлять команды, вызывая её методы
// Список методов видно если после .NewQueue поставить точку
// (это касается вообще всех типов, но тут особенно полезно)
// 

// 3.1.2 - Создание очередей из подпрограммы, написанной для CPU
// 
// Иногда между командами для GPU надо вставить выполнение обычного кода на паскале
// И в большинстве таких случаев - ужастно неудобно разрывать очередь на 2
// (1 целая очередь всегда выполниться быстрее 2 её частей)
// 
// В таких случаях - можно использовать глобальные подпрограммы HFQ и HPQ
// Они возвращают очередь, выполняющую код (функцию/процедуру соответственно) на CPU
// 

// 3.1.3 - Объединение очередей
// 
// Если сложить 2 очереди A и B ("var C := A+B") - получаем очередь C, в которой сначала выполняется A, а затем B
// Очередь C будет считаться выполненной тогда, когда выполнится очередь B
// Очередь C будет возвращать то, что вернула очередь B
// 
// Если умножить 2 очереди A и B ("var C := A*B") - получаем очередь C, в которой одновременно начнут выполняться A и B
// Очередь C будет считаться выполненной тогда, когда обе очереди (A и B) выполнятся
// Очередь C будет возвращать то, что вернула очередь B
// 
// Как и в математике, умножение имеет бОльший приоритет чем сложение
// 
// 
// Операторы += и *= так же применимы к очередям
// И как и для чисел - "A += B" разворачивается в "A := A+B", и так же с *=
// Это так же значит, что возвращаемые типы A и B должны быть одинаковыми, чтоб к ним можно было применить +=/*=
// 
// 
// Если надо сложить много очередей - лучше применять CombineSyncQueue
// Если надо умножить много очередей - лучше применять CombineAsyncQueue
// Эти подпрограммы работают немного быстрее чем сложение и умножение, если вы объеденяете больше 2 очередей за раз
// 
// Кроме того, CombineSyncQueue и CombineAsyncQueue могут принимать ещё 1 параметр перед очередями
// Этот параметр позволяет указать функцию преобразования, использующую результаты всех входных очередей
// 

// 3.1.4 - CommandQueue.ThenConvert (Прикрепление очередей)
// 
// Допустим имеем очередь типа CommandQueue<integer>
// А для дальнейшей обработки - нам зачем то нужна очередь типа CommandQueue<string>
// 
// Так вот, их можно преобразовать друг к другу:
// <------------------------->
// var Q1 := HFQ(()->123); // "()->123" это функция-лямбда, принимающая ничего и возвращающая 123 (которое, по-умолчанию, integer)
// var Q2 := Q1.ThenConvert(i -> $'"{i}"' ) // $'' это форматная строка, в ней всё что в {} заменяется на своё значение
// Context.Default.SyncInvoke(Q2).Println; // выведет строку: "123"
// <------------------------->
// То есть, метод CommandQueue.ThenConvert возвращает очередь
// Которая сначала выполняет ту очередь, для которой вызвали .ThenConvert
// А затем применит к полученному значению какое то преобразование
// 

// 3.1.5 - CommandQueue.Cycle (Повторение очередей)
// 
// ToDo
// 

// 3.1.6 - Неявное создание очередей (Передача по 1 команде)
// 
// Передавать команды по одной, когда их несколько - ужастно медленно
// Но не редко бывает так, что команда все одна
// Или для дебага надо как то по-простому одноразово вызвать 1 команду
// 
// Для таких случаев - можно создавать очереди неявно
// Это можно сделать, вызвав метод переменной типа Buffer/Kernel
// 
// Почти у каждого метода очереди, созданной с .NewQueue - есть дублирующий метод в оригинальном объекте
// Этот метод создаёт новую очередь, добавляет 1 соответствующую команду и выполняет полученную очередь с SyncInvoke
// Подробнее в примере "3 - Очередь\Код с очередью и без.pas"
// 
// Кроме того, у типа Buffer есть дополнительные методы "Buffer.Get..."
// Соответствующих методов у очереди - нету //ToDo но вообще я собираюсь это исправить
// Методы ".Get..." создают новый объект типа записи, массива или выделяют область неуправляемой памяти,
// читают в полученный объект содержимое буфера и возвращают этот объект
// Они так же используют неявную очередь (для чтения буфера)
// 

// 3.1.7 - Buffer.ValueQueue (Очередь из размерного значения, то есть записи)
// 
// Статичный метод Buffer.ValueQueue создаёт новый буфер
// Затем создаёт из него новую очередь
// И добавляет в полученную очередь команду записи размерного значения в эту очередь
// 
// Это полезно, к примеру, если вам надо передать одним из параметров в карнел - размер передаваемого массива, потому что массивы в C не хранят свой размер
// Но будьте осторожны, этим методом не стоит злоупотреблять, потому что каждый вызов создаёт новый буфер
// 
// Если вы запускаете карнел в который надо передавать число одним из параметров - лучше создайте буфер 1 раз
// И записывайте в него значение перед каждым вызовом карнела, используя .NewQueue.WriteValue
// 
// Если же вам нужна какая то константа - можно 1 раз вызвать Buffer.ValueQueue и далее использовать эту переменную (но не добавлять в неё команды)
// 

{$endregion 3.1. Создание очередей}

{$region 3.2 - Выполнение очередей}

// 
// Самый простой способ выполнить очередь - метод Context.SyncInvoke
// Он выполняет очередь и после того как она завершилась - возвращает то, что вернула эта очередь
// 
// Но Context.SyncInvoke в свою очередь работает через метод Context.BeginInvoke
// метод Context.BeginInvoke начинает выполнение очереди и возвращает объект типа Task
// 

// У Task, так же как у очереди - в <> указывается возвращаемое значение
// Через объект типа Task можно:
// - Следить за выполнением, через различные свойства типа Task
// - Ожидать пока выполнение не закончиться, методом Task.Wait
// - Получать возвращаемое значение после выполнения, свойством Task.Result
// 

// Если при выполнении очереди возникнет ошибка - о ней выведет не полную информацию
// Чтоб получить достаточно информации чтоб понять что за ошибка - используйте следующую конструкцию:
// <------------------------->
// try
//   
//   // ваш код, вызывающий ошибку
//   
// except
//   on e: Exception do writeln(e); // writeln выводит все внутренние исключения, поэтому в нём видно что произошло на самом деле
// end;
// <------------------------->
// Для данного кода есть стандартный снипет
// Чтоб активировать его - напишите "tryo" и нажмите Shift+Space
// 

{$endregion 3.2 - Выполнение очередей}

{$region 3.3 - Очереди как параметры}

// 
// Почти все параметры всех методов, создающих очередь
// (включая те, что создают неявную очередь)
// Могут принимать вместо любого параметра - очередь
// (анализатор кода об этом не говорит, чтоб небыло 100500 перегрузок каждого метода)
// Но в таком случае, передаваемая очередь должна возвращать то, что принимает параметр
// Подробнее в примере "1.2 - Очереди\Использование очереди как парамметра.pas"
// 
// Очереди, переданные параметрами - выполняются в не предсказуемом порядке, но подчиняются следующим правилам:
// 1. Все очереди-параметры начинают выполняться прямо при вызове Context.BeginInvoke
// 2. Все очереди-параметры команды A выполняться до того как начнёт выполняться сама команда A
// 
// Так же, никто не запрещает передавать очередь-параметр, в метод,
// создающий команду, которая сама является частью другой очереди-параметра
// Все те же правила действуют в этом случае
// 

{$endregion 3.3 - Очереди как параметры}

{$region 3.4. Множественное использование очереди}

// 3.4.0
// 
// Одну и ту же очередь можно использовать несколько раз:
// <------------------------->
// var Q1: CommandQueue<...>;
// ...
// Context.Default.SyncInvoke(Q1);
// Context.Default.SyncInvoke(Q1);
// <------------------------->
// 
// Однако, во время выполнения - очередь хранит в себе данные о своём состоянии выполнения и результат, когда он уже вычислен
// Это значит, что 1 объект очереди нельзя выполнять в 2 местах параллельно
// Иначе данные о состоянии и результате - перемешаются
// То есть такой код:
// <------------------------->
// var Q1: CommandQueue<...>;
// ...
// Context.Default.SyncInvoke( Q1 * Q1 );
// <------------------------->
// Приведёт к неопределённом поведению
// То есть вы получите какой то мусор после выполнения этого кода
// Так же, 50/50 может вылететь исключение QueueDoubleInvokeException, объясняющее, что вы напортачили
// Но не надейтесь на исключение, в определённом коде оно может и не вылетать вообще
// Вместо этого следите ещё при написании кода, чтоб у вас не было такой ошибки
// 
// Есть 2 способа обойти это ограничение:
// 

// 3.4.1 - Клонирование очередей
//ToDo сейчас не работает, потому что issue компилятора #2070
// 
// Методом CommandQueue.Clone можно создать полную копию очереди
// При этом, если исходная очередь проводила какие то вычисления
// Они будут произведены дважды, оригиналом и копией, при вызове обоих
// 
// Клон очереди является полностью независимым объектом
// Его можно вызывать не только параллельно с оригиналом
// Оригинал и клон можно вызывать даже в 2 разных Context.BeginInvoke одновременно
// 

// 3.4.2 - Удленители для очередей (.Multiusable)
// 
// Вариант выполнять очередь несколько раз, как в случае с .Clone -
// Не редко не подходит, потому что это удваивает затраты производительности
// И некоторые очереди (как выполнение карнелов) могут давать разные результаты, если выполнить их лишний раз
// 
// Если вам надо использовать результат 1 очереди многократно - лучше использоват метод CommandQueue.Multiusable
// Созданные таким образом очереди - НЕ является независимыми объектами
// 
// .Multiusable работает как провод-удленитель для розетки,
// если сравнивать возвращаемое значение очереди с розеткой
// 
// Исходная очередь, для которой вызвали .Multiusable - подчиняется всем тем же правилам что и очередь-параметр
// То есть, она начинает выполнятся прямо во время вызов Context.BeginInvoke
// И она всегда выполнится до того как начнёт выполнятся любая из очередей, которую вернул метод .Multiusable
// 
// Очереди, которые вернул .Multiusable - могут быть использованы параллельно:
// <------------------------->
// var Q1: CommandQueue<...>;
// ...
// Qs1 := Q1.Multiusable(3); // создаёт массив из 3 очередей
// Context.Default.SyncInvoke( Qs1[0] * Qs1[1] * Qs1[2].ThenConvert(o->...) );
// <------------------------->
// Однако, все очереди, полученные из .Multiusable всё ещё связаны оригинальной очередью
// А так как Context.BeginInvoke управляет переключением состояния выполнения очереди
// Следующий код как бы 2 раза запустит очередь Q1, и после этого 2 раза её завершит:
// <------------------------->
// var Q1: CommandQueue<...>;
// ...
// Qs1 := Q1.Multiusable(2);
// Context.Default.BeginInvoke( Qs1[0] );
// Context.Default.BeginInvoke( Qs1[1] );
// <------------------------->
// Поэтому такой код тоже приведёт к неопределённом поведению
// 

{$endregion 3.4. Множественное использование очереди}

{$endregion 3. Очередь [команд] (CommandQueue)}

{$region 4 - Буфер (Buffer)}

// 
// Буфер создаётся через конструктор ("new Buffer(...)")
// Однако память на GPU выделяется только тогда при вызове метода Buffer.Init
// Исходя из контекста, переданного Buffer.Init - выбирается на каком девайсе будет выделена память
// При выделения памяти - содержимое буфера НЕ отчищается нулями
// Повторный вызов Buffer.Init - перевыделяет память
// 
// Если Buffer.Init небыл вызван до первой операции чтения/записи буфера - он будет вызван автоматически
// В таком случае в качестве контекста для выделения памяти выбирается тот, для которого был вызван метод Context.BeginInvoke
// 
// Буфер можно удалить, вызвав метод Buffer.Dispose
// Но этот метод только освобождает память на GPU
// Если после .Dispose использовать буфер снова - память выделится заново
// .Dispose так же вызывается автоматически, если в программе не остаётся ссылок на буфер
// 

{$endregion 4 - Буфер (Buffer)}

{$region 5. Контейнер для кода (ProgramCode)}

{$region 5.1. Создание ProgramCode}

// 5.1.1 - Создание из исходного кода
// 
// Конструктор ProgramCode("new ProgramCode(...)") принимает текст исходников программы на языке OpenCL-C
// Исходный код - это текст программы
// Так же как исходники паскаля хранятся в .pas файлах
// Исходники кода для OpenCL обычно хранят в .cl файлах
// Вообще это не принципиально, раз конструктор ProgramCode принимает текст, а не имя файла
// А значит, код не обязательно должен быть в файле, он может быть в любой форме текста
// Но хранение в .cl файлах упрощает вам жизнь, потому что тогда сложно будет перепутать, что в них хранится
// 

// 5.1.2 - Создание из бинарников
// 
// После создания объекта типа ProgramCode из исходников
// Можно вызвать метод ProgramCode.SerializeTo, чтоб сохранить код в бинарном и прекомпилированном виде
// Это обычно делается отдельной программой (не той же самой, которая будет использовать этот бинарный код)
// 
// После этого основная программа может создать объект ProgramCode
// Используя статичный метод ProgramCode.DeserializeFrom
// 

{$endregion 5.1. Создание ProgramCode}

{$endregion 5. Контейнер для кода (ProgramCode)}

{$region 6 - Карнел (Kernel)}

// 
// Карнел создаётся через индесной свойтсво ProgramCode:
// code['KernelName']
// Где code имеет тип ProgramCode
// А 'KernelName' - имя подпрограммы-карнела в исходном коде (регистр важен!)
// 
// Карнел вызывается методом KernelCommandQueue.Exec
// См. пример "1.6 - Карнел\Вызов карнела.pas"
// 

{$endregion 6 - Карнел (Kernel)}

{$endregion Подробное описание OpenCLABC (аля справка)}

interface

uses OpenCL;
uses System;
uses System.Threading.Tasks;
uses System.Runtime.InteropServices;
uses System.Runtime.CompilerServices;

//===================================
// Обязательно сделать до следующего пула:

//===================================
// Запланированное:

//ToDo Read/Write для массивов - надо бы иметь возможность указывать отступ в массиве

//ToDo CommandQueue.Cycle(integer)
//ToDo CommandQueue.Cycle // бесконечность циклов
//ToDo CommandQueue.CycleWhile(***->boolean)
// - возможность передать свой обработчик ошибок как procedure->()

//ToDo Может лучше передавать List<Task> в Invoke, чем использовать yield?
// - должно быть проще в реализации, быстрее и меньше ограничений...

//ToDo Типы Device и Platform
//ToDo А связь с OpenCL.pas сделать всему (и буферам и карнелам), но более человеческую

//ToDo Сделать методы BufferCommandQueue.AddGet
// - они особенные, потому что возвращают не BufferCommandQueue, а каждый свою очередь
// - полезно, потому что SyncInvoke такой очереди будет возвращать полученное значение

//ToDo У всего, у чего есть Finalize - проверить чтоб было и .Dispose, если надо
// - и добавить в справку, про то что этот объект можно удалять

//===================================
// Сделать когда-нибуть:

//ToDo Клонирование очередей
// - для паралельного выполнения из разных потоков
// - #2070 мешает

//ToDo Больше примеров... Желательно хотя бы по примеру на под-раздел справки

//ToDo Тесты всех фич модуля

//ToDo issue компилятора:
// - #1952
// - #1981
// - #2067, #2068
// - #2070

type
  
  {$region misc class def}
  
  Context = class;
  Buffer = class;
  Kernel = class;
  ProgramCode = class;
  DeviceTypeFlags = OpenCL.DeviceTypeFlags;
  
  QueueDoubleInvokeException = class(Exception)
    
    public constructor :=
    inherited Create('Нельзя выполнять одну и ту же очередь в 2 местах одновременно. Используйте .Clone или .Multiusable');
    
  end;
  
  {$endregion misc class def}
  
  {$region CommandQueue}
  
  ///--
  CommandQueueBase = abstract class
    protected ev: cl_event;
    protected is_busy: boolean;
    
    protected procedure ClearEvent :=
    if self.ev<>cl_event.Zero then cl.ReleaseEvent(self.ev).RaiseIfError;
    
    protected procedure MakeBusy :=
    if not self.is_busy then is_busy := true else
      raise new QueueDoubleInvokeException;
    
    protected function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; abstract;
    protected procedure UnInvoke; virtual :=
    if self.is_busy then is_busy := false else
      raise new InvalidOperationException('Ошибка внутри модуля OpenCLABC: совершена попыта завершить не запущенную очередь. Сообщите, пожалуйста, разработчику OpenCLABC');
    
    protected function GetRes: object; abstract;
    
  end;
  /// Базовый тип всех очередей команд в OpenCLABC
  CommandQueue<T> = abstract class(CommandQueueBase)
    protected res: T;
    
    protected function GetRes: object; override := self.res;
    
    
//    ///Создаёт полную копию данной очереди,
//    ///Всех очередей из которых она состоит,
//    ///А так же всех очередей-параметров, использованных в данной очереди
//    public function Clone: CommandQueue<T>; abstract;
    
    
    public function Multiusable(n: integer): array of CommandQueue<T>;
    
    
    ///Создаёт очередь, которая выполнит данную
    ///А затем выполнит на CPU функцию f
    public function ThenConvert<T2>(f: T->T2): CommandQueue<T2>;
    
    
    public static function operator+<T2>(q1: CommandQueue<T>; q2: CommandQueue<T2>): CommandQueue<T2>;
    public static procedure operator+=(var q1: CommandQueue<T>; q2: CommandQueue<T>) := q1 := q1+q2;
    
    public static function operator*<T2>(q1: CommandQueue<T>; q2: CommandQueue<T2>): CommandQueue<T2>;
    public static procedure operator*=(var q1: CommandQueue<T>; q2: CommandQueue<T>) := q1 := q1*q2;
    
    
    public static function operator implicit(o: T): CommandQueue<T>;
    
  end;
  
  {$endregion CommandQueue}
  
  {$region Buffer}
  
  ///--
  BufferCommand = abstract class
    protected ev: cl_event;
    
    protected procedure ClearEvent :=
    if self.ev<>cl_event.Zero then cl.ReleaseEvent(self.ev).RaiseIfError;
    
    protected function Invoke(b: Buffer; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; abstract;
    
    protected procedure UnInvoke; abstract;
    
  end;
  
  ///--
  BufferCommandQueue = sealed class(CommandQueue<Buffer>)
    protected commands := new List<BufferCommand>;
    
    {$region constructor's}
    
    protected constructor(org: Buffer) :=
    self.res := org;
    
    protected function AddCommand(comm: BufferCommand): BufferCommandQueue;
    begin
      self.commands += comm;
      Result := self;
    end;
    
    {$endregion constructor's}
    
    {$region AddQueue}
    
    public function AddQueue<T>(q: CommandQueue<T>): BufferCommandQueue;
    
    {$endregion AddQueue}
    
    {$region Write}
    
    ///- function WriteData(ptr: IntPtr): BufferCommandQueue;
    ///Копирует область оперативной памяти, на которую ссылается ptr, в данный буфер
    ///Копируется нужное кол-во байт чтоб заполнить весь буфер
    public function AddWriteData(ptr: CommandQueue<IntPtr>): BufferCommandQueue;
    ///- function WriteData(ptr: IntPtr; offset, len: integer): BufferCommandQueue;
    ///Копирует область оперативной памяти, на которую ссылается ptr, в данный буфер
    ///offset это отступ в буфере, а len - кол-во копируемых байтов
    public function AddWriteData(ptr: CommandQueue<IntPtr>; offset, len: CommandQueue<integer>): BufferCommandQueue;
    
    ///- function WriteData(ptr: pointer): BufferCommandQueue;
    ///Копирует область оперативной памяти, на которую ссылается ptr, в данный буфер
    ///Копируется нужное кол-во байт чтоб заполнить весь буфер
    public function AddWriteData(ptr: pointer) := AddWriteData(IntPtr(ptr));
    ///- function WriteData(ptr: pointer; offset, len: integer): BufferCommandQueue;
    ///Копирует область оперативной памяти, на которую ссылается ptr, в данный буфер
    ///offset это отступ в буфере, а len - кол-во копируемых байтов
    public function AddWriteData(ptr: pointer; offset, len: CommandQueue<integer>) := AddWriteData(IntPtr(ptr), offset, len);
    
    
    ///- function WriteArray(a: Array): BufferCommandQueue;
    ///Копирует содержимое массива в данный буфер
    ///Копируется нужное кол-во байт чтоб заполнить весь буфер
    public function AddWriteArray(a: CommandQueue<&Array>): BufferCommandQueue;
    ///- function WriteArray(a: Array; offset, len: integer): BufferCommandQueue;
    ///Копирует содержимое массива в данный буфер
    ///offset это отступ в буфере, а len - кол-во копируемых байтов
    public function AddWriteArray(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>): BufferCommandQueue;
    
    ///- function WriteArray(a: Array): BufferCommandQueue;
    ///Копирует содержимое массива в данный буфер
    ///Копируется нужное кол-во байт чтоб заполнить весь буфер
    public function AddWriteArray(a: &Array) := AddWriteArray(CommandQueue&<&Array>(a));
    ///- function WriteArray(a: Array; offset, len: integer): BufferCommandQueue;
    ///Копирует содержимое массива в данный буфер
    ///offset это отступ в буфере, а len - кол-во копируемых байтов
    public function AddWriteArray(a: &Array; offset, len: CommandQueue<integer>) := AddWriteArray(CommandQueue&<&Array>(a), offset, len);
    
    
    ///- function WriteValue<TRecord>(val: TRecord; offset: integer := 0): BufferCommandQueue; where TRecord: record;
    ///Записывает значение любого размерного типа в данный буфер
    ///С отступом в offset байт в буфере
    public [MethodImpl(MethodImplOptions.AggressiveInlining)] function AddWriteValue<TRecord>(val: TRecord; offset: CommandQueue<integer> := 0): BufferCommandQueue; where TRecord: record;
    
    ///- function WriteValue<TRecord>(val: TRecord; offset: integer := 0): BufferCommandQueue; where TRecord: record;
    ///Записывает значение любого размерного типа в данный буфер
    ///С отступом в offset байт в буфере
    public function AddWriteValue<TRecord>(val: CommandQueue<TRecord>; offset: CommandQueue<integer> := 0): BufferCommandQueue; where TRecord: record;
    
    {$endregion Write}
    
    {$region Read}
    
    ///- function ReadData(ptr: IntPtr): BufferCommandQueue;
    ///Копирует всё содержимое буффера в область оперативной памяти, на которую указывает ptr
    public function AddReadData(ptr: CommandQueue<IntPtr>): BufferCommandQueue;
    ///- function ReadData(ptr: IntPtr; offset, len: integer): BufferCommandQueue;
    ///Копирует len байт, начиная с байта №offset в буфере, в область оперативной памяти, на которую указывает ptr
    public function AddReadData(ptr: CommandQueue<IntPtr>; offset, len: CommandQueue<integer>): BufferCommandQueue;
    
    ///- function ReadData(ptr: pointer): BufferCommandQueue;
    ///Копирует всё содержимое буффера в область оперативной памяти, на которую указывает ptr
    public function AddReadData(ptr: pointer) := AddReadData(IntPtr(ptr));
    ///- function ReadData(ptr: pointer; offset, len: integer): BufferCommandQueue;
    ///Копирует len байт, начиная с байта №offset в буфере, в область оперативной памяти, на которую указывает ptr
    public function AddReadData(ptr: pointer; offset, len: CommandQueue<integer>) := AddReadData(IntPtr(ptr), offset, len);
    
    ///- function ReadArray(a: Array): BufferCommandQueue;
    ///Копирует всё содержимое буффера в содержимое массива
    public function AddReadArray(a: CommandQueue<&Array>): BufferCommandQueue;
    ///- function ReadArray(a: Array; offset, len: integer): BufferCommandQueue;
    ///Копирует len байт, начиная с байта №offset в буфере, в содержимое массива
    public function AddReadArray(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>): BufferCommandQueue;
    
    ///- function ReadArray(a: Array): BufferCommandQueue;
    ///Копирует всё содержимое буффера в содержимое массива
    public function AddReadArray(a: &Array) := AddReadArray(CommandQueue&<&Array>(a));
    ///- function ReadArray(a: Array; offset, len: integer): BufferCommandQueue;
    ///Копирует len байт, начиная с байта №offset в буфере, в содержимое массива
    public function AddReadArray(a: &Array; offset, len: CommandQueue<integer>) := AddReadArray(CommandQueue&<&Array>(a), offset, len);
    
    ///- function ReadValue<TRecord>(var val: TRecord; offset: integer := 0): BufferCommandQueue; where TRecord: record;
    ///Читает значение любого размерного типа из данного буфера
    ///С отступом в offset байт в буфере
    public function AddReadValue<TRecord>(var val: TRecord; offset: CommandQueue<integer> := 0): BufferCommandQueue; where TRecord: record;
    begin
      Result := AddReadData(@val, offset, Marshal.SizeOf&<TRecord>);
    end;
    
    {$endregion Read}
    
    {$region Fill}
    
    ///- function PatternFill(ptr: IntPtr): BufferCommandQueue;
    ///Заполняет весь буфер копиями массива байт, длинной pattern_len,
    ///прочитанным из области оперативной памяти, на которую указывает ptr
    public function AddFillData(ptr: CommandQueue<IntPtr>; pattern_len: CommandQueue<integer>): BufferCommandQueue;
    ///- function PatternFill(ptr: IntPtr; offset, len: integer): BufferCommandQueue;
    ///Заполняет часть буфера (начиная с байта №offset и длинной len) копиями массива байт, длинной pattern_len,
    ///прочитанным из области оперативной памяти, на которую указывает ptr
    public function AddFillData(ptr: CommandQueue<IntPtr>; pattern_len, offset, len: CommandQueue<integer>): BufferCommandQueue;
    
    ///- function PatternFill(ptr: pointer): BufferCommandQueue;
    ///Заполняет весь буфер копиями массива байт, длинной pattern_len,
    ///прочитанным из области оперативной памяти, на которую указывает ptr
    public function AddFillData(ptr: pointer; pattern_len: CommandQueue<integer>) := AddFillData(IntPtr(ptr), pattern_len);
    ///- function PatternFill(ptr: pointer; offset, len: integer): BufferCommandQueue;
    ///Заполняет часть буфера (начиная с байта №offset и длинной len) копиями массива байт, длинной pattern_len,
    ///прочитанным из области оперативной памяти, на которую указывает ptr
    public function AddFillData(ptr: pointer; pattern_len, offset, len: CommandQueue<integer>) := AddFillData(IntPtr(ptr), pattern_len, offset, len);
    
    ///- function PatternFill(a: Array): BufferCommandQueue;
    ///Заполняет весь буфер копиями содержимого массива
    public function AddFillArray(a: CommandQueue<&Array>): BufferCommandQueue;
    ///- function PatternFill(a: Array; offset, len: integer): BufferCommandQueue;
    ///Заполняет часть буфера (начиная с байта №offset и длинной len) копиями содержимого массива
    public function AddFillArray(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>): BufferCommandQueue;
    
    ///- function PatternFill(a: Array): BufferCommandQueue;
    ///Заполняет весь буфер копиями содержимого массива
    public function AddFillArray(a: &Array) := AddFillArray(CommandQueue&<&Array>(a));
    ///- function PatternFill(a: Array; offset, len: integer): BufferCommandQueue;
    ///Заполняет часть буфера (начиная с байта №offset и длинной len) копиями содержимого массива
    public function AddFillArray(a: &Array; offset, len: CommandQueue<integer>) := AddFillArray(CommandQueue&<&Array>(a), offset, len);
    
    ///- function PatternFill<TRecord>(val: TRecord): BufferCommandQueue; where TRecord: record;
    ///Заполняет весь буфер копиями значения любого размерного типа
    public [MethodImpl(MethodImplOptions.AggressiveInlining)] function AddFillValue<TRecord>(val: TRecord): BufferCommandQueue; where TRecord: record;
    ///- function PatternFill<TRecord>(val: TRecord; offset, len: integer): BufferCommandQueue; where TRecord: record;
    ///Заполняет часть буфера (начиная с байта №offset и длинной len) копиями значения любого размерного типа
    public [MethodImpl(MethodImplOptions.AggressiveInlining)] function AddFillValue<TRecord>(val: TRecord; offset, len: CommandQueue<integer>): BufferCommandQueue; where TRecord: record;
    
    ///- function PatternFill<TRecord>(val: TRecord): BufferCommandQueue; where TRecord: record;
    ///Заполняет весь буфер копиями значения любого размерного типа
    public function AddFillValue<TRecord>(val: CommandQueue<TRecord>): BufferCommandQueue; where TRecord: record;
    ///- function PatternFill<TRecord>(val: TRecord; offset, len: integer): BufferCommandQueue; where TRecord: record;
    ///Заполняет часть буфера (начиная с байта №offset и длинной len) копиями значения любого размерного типа
    public function AddFillValue<TRecord>(val: CommandQueue<TRecord>; offset, len: CommandQueue<integer>): BufferCommandQueue; where TRecord: record;
    
    {$endregion Fill}
    
    {$region Copy}
    
    ///- function CopyFrom(b: Buffer; from, &to, len: integer): BufferCommandQueue;
    ///Копирует содержимое буфера b в данный буфер
    ///from - отступ в буффере b
    ///to   - отступ в данном буффере
    ///len  - кол-во копируемых байт
    public function AddCopyFrom(b: CommandQueue<Buffer>; from, &to, len: CommandQueue<integer>): BufferCommandQueue;
    ///- function CopyTo(b: Buffer; from, &to, len: integer): BufferCommandQueue;
    ///Копирует содержимое данного буфера в буфер b
    ///from - отступ в данном буффере
    ///to   - отступ в буффере b
    ///len  - кол-во копируемых байт
    public function AddCopyTo  (b: CommandQueue<Buffer>; from, &to, len: CommandQueue<integer>): BufferCommandQueue;
    
    ///- function CopyFrom(b: Buffer): BufferCommandQueue;
    ///Копирует всё содержимое буфера b в данный буфер
    public function AddCopyFrom(b: CommandQueue<Buffer>): BufferCommandQueue;
    ///- function CopyTo(b: Buffer): BufferCommandQueue;
    ///Копирует всё содержимое данного буфера в буфер b
    public function AddCopyTo  (b: CommandQueue<Buffer>): BufferCommandQueue;
    
    {$endregion Copy}
    
    {$region reintroduce методы}
    
    private function Equals(obj: object): boolean; reintroduce := false;
    
    private function ToString: string; reintroduce := nil;
    
    private function GetType: System.Type; reintroduce := nil;
    
    private function GetHashCode: integer; reintroduce := 0;
    
    {$endregion reintroduce методы}
    
//    ///Создаёт полную копию данной очереди,
//    ///Всех команд из которых она состоит,
//    ///А так же всех очередей-параметров, использованных в данной очереди
//    public function Clone: CommandQueue<T>; override;
//    begin
//      
//    end;
    
    protected function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      MakeBusy;
      
      foreach var comm in commands do
      begin
        yield sequence comm.Invoke(res, c, cq, prev_ev);
        prev_ev := comm.ev;
      end;
      
      self.ev := prev_ev;
    end;
    
    protected procedure UnInvoke; override;
    begin
      inherited;
      foreach var comm in commands do comm.UnInvoke;
    end;
    
  end;
  
  ///Буфер, хранящий своё содержимое в памяти GPU (обычно)
  ///Используется для передачи данных в Kernel-ы перед их выполнением
  Buffer = sealed class(IDisposable)
    private memobj: cl_mem;
    private sz: UIntPtr;
    private _parent: Buffer;
    
    {$region constructor's}
    
    private constructor := raise new System.NotSupportedException;
    
    ///Создаён не_инициализированный буфер с размером size байт
    public constructor(size: UIntPtr) := self.sz := size;
    ///Создаён не_инициализированный буфер с размером size байт
    public constructor(size: integer) := Create(new UIntPtr(size));
    ///Создаён не_инициализированный буфер с размером size байт
    public constructor(size: int64)   := Create(new UIntPtr(size));
    
    ///Создаёт под-буфер размера size и с отступом в данном буфере offset
    ///Под буфер имеет общую память с оригинальным, но иммеет доступ только к её части
    public function SubBuff(offset, size: integer): Buffer; 
    
    ///Инициализирует буфер, выделяя память на девайсе - который связан с данным контекстом
    public procedure Init(c: Context);
    
    {$endregion constructor's}
    
    {$region property's}
    
    ///Возвращает размер буфера в байтах
    public property Size: UIntPtr read sz;
    ///Возвращает размер буфера в байтах
    public property Size32: UInt32 read sz.ToUInt32;
    ///Возвращает размер буфера в байтах
    public property Size64: UInt64 read sz.ToUInt64;
    
    ///Если данный буфер был создан функцией SubBuff - возвращает родительский буфер
    ///Иначе возвращает nil
    public property Parent: Buffer read _parent;
    
    {$endregion property's}
    
    {$region Queue's}
    
    ///Создаёт новую очередь-обёртку данного буфера
    ///Которая может хранить множество операций чтения/записи одновременно
    public function NewQueue :=
    new BufferCommandQueue(self);
    
    /// - static function ValueQueue<TRecord>(val: TRecord): BufferCommandQueue; where TRecord: record;
    ///Создаёт новый буфер того же размера что и val, оборачивает в очередь
    ///И вызывает у полученной очереди .WriteValue(val)
    public [MethodImpl(MethodImplOptions.AggressiveInlining)] static function ValueQueue<TRecord>(val: TRecord): BufferCommandQueue; where TRecord: record;
    begin
      Result := 
        Buffer.Create(Marshal.SizeOf&<TRecord>)
        .NewQueue.AddWriteValue(val);
    end;
    
    {$endregion Queue's}
    
    {$region Write}
    
    ///- function WriteData(ptr: IntPtr): BufferCommandQueue;
    ///Копирует область оперативной памяти, на которую ссылается ptr, в данный буфер
    ///Копируется нужное кол-во байт чтоб заполнить весь буфер
    public function WriteData(ptr: CommandQueue<IntPtr>): Buffer;
    ///- function WriteData(ptr: IntPtr; offset, len: integer): BufferCommandQueue;
    ///Копирует область оперативной памяти, на которую ссылается ptr, в данный буфер
    ///offset это отступ в буфере, а len - кол-во копируемых байтов
    public function WriteData(ptr: CommandQueue<IntPtr>; offset, len: CommandQueue<integer>): Buffer;
    
    ///- function WriteData(ptr: pointer): BufferCommandQueue;
    ///Копирует область оперативной памяти, на которую ссылается ptr, в данный буфер
    ///Копируется нужное кол-во байт чтоб заполнить весь буфер
    public function WriteData(ptr: pointer) := WriteData(IntPtr(ptr));
    ///- function WriteData(ptr: pointer; offset, len: integer): BufferCommandQueue;
    ///Копирует область оперативной памяти, на которую ссылается ptr, в данный буфер
    ///offset это отступ в буфере, а len - кол-во копируемых байтов
    public function WriteData(ptr: pointer; offset, len: CommandQueue<integer>) := WriteData(IntPtr(ptr), offset, len);
    
    
    ///- function WriteArray(a: Array): BufferCommandQueue;
    ///Копирует содержимое массива в данный буфер
    ///Копируется нужное кол-во байт чтоб заполнить весь буфер
    public function WriteArray(a: CommandQueue<&Array>): Buffer;
    ///- function WriteArray(a: Array; offset, len: integer): BufferCommandQueue;
    ///Копирует содержимое массива в данный буфер
    ///offset это отступ в буфере, а len - кол-во копируемых байтов
    public function WriteArray(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>): Buffer;
    
    ///- function WriteArray(a: Array): BufferCommandQueue;
    ///Копирует содержимое массива в данный буфер
    ///Копируется нужное кол-во байт чтоб заполнить весь буфер
    public function WriteArray(a: &Array) := WriteArray(CommandQueue&<&Array>(a));
    ///- function WriteArray(a: Array; offset, len: integer): BufferCommandQueue;
    ///Копирует содержимое массива в данный буфер
    ///offset это отступ в буфере, а len - кол-во копируемых байтов
    public function WriteArray(a: &Array; offset, len: CommandQueue<integer>) := WriteArray(CommandQueue&<&Array>(a), offset, len);
    
    
    ///- function WriteValue<TRecord>(val: TRecord; offset: integer := 0): BufferCommandQueue; where TRecord: record;
    ///Записывает значение любого размерного типа в данный буфер
    ///С отступом в offset байт в буфере
    public [MethodImpl(MethodImplOptions.AggressiveInlining)] function WriteValue<TRecord>(val: TRecord; offset: CommandQueue<integer> := 0): Buffer; where TRecord: record;
    begin Result := WriteData(@val, offset, Marshal.SizeOf&<TRecord>); end;
    
    ///- function WriteValue<TRecord>(val: TRecord; offset: integer := 0): BufferCommandQueue; where TRecord: record;
    ///Записывает значение любого размерного типа в данный буфер
    ///С отступом в offset байт в буфере
    public function WriteValue<TRecord>(val: CommandQueue<TRecord>; offset: CommandQueue<integer> := 0): Buffer; where TRecord: record;
    
    {$endregion Write}
    
    {$region Read}
    
    ///- function ReadData(ptr: IntPtr): BufferCommandQueue;
    ///Копирует всё содержимое буффера в область оперативной памяти, на которую указывает ptr
    public function ReadData(ptr: CommandQueue<IntPtr>): Buffer;
    ///- function ReadData(ptr: IntPtr; offset, len: integer): BufferCommandQueue;
    ///Копирует len байт, начиная с байта №offset в буфере, в область оперативной памяти, на которую указывает ptr
    public function ReadData(ptr: CommandQueue<IntPtr>; offset, len: CommandQueue<integer>): Buffer;
    
    ///- function ReadData(ptr: pointer): BufferCommandQueue;
    ///Копирует всё содержимое буффера в область оперативной памяти, на которую указывает ptr
    public function ReadData(ptr: pointer) := ReadData(IntPtr(ptr));
    ///- function ReadData(ptr: pointer; offset, len: integer): BufferCommandQueue;
    ///Копирует len байт, начиная с байта №offset в буфере, в область оперативной памяти, на которую указывает ptr
    public function ReadData(ptr: pointer; offset, len: CommandQueue<integer>) := ReadData(IntPtr(ptr), offset, len);
    
    ///- function ReadArray(a: Array): BufferCommandQueue;
    ///Копирует всё содержимое буффера в содержимое массива
    public function ReadArray(a: CommandQueue<&Array>): Buffer;
    ///- function ReadArray(a: Array; offset, len: integer): BufferCommandQueue;
    ///Копирует len байт, начиная с байта №offset в буфере, в содержимое массива
    public function ReadArray(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>): Buffer;
    
    ///- function ReadArray(a: Array): BufferCommandQueue;
    ///Копирует всё содержимое буффера в содержимое массива
    public function ReadArray(a: &Array) := ReadArray(CommandQueue&<&Array>(a));
    ///- function ReadArray(a: Array; offset, len: integer): BufferCommandQueue;
    ///Копирует len байт, начиная с байта №offset в буфере, в содержимое массива
    public function ReadArray(a: &Array; offset, len: CommandQueue<integer>) := ReadArray(CommandQueue&<&Array>(a), offset, len);
    
    ///- function ReadValue<TRecord>(var val: TRecord; offset: integer := 0): BufferCommandQueue; where TRecord: record;
    ///Читает значение любого размерного типа из данного буфера
    ///С отступом в offset байт в буфере
    public function ReadValue<TRecord>(var val: TRecord; offset: CommandQueue<integer> := 0): Buffer; where TRecord: record;
    begin
      Result := ReadData(@val, offset, Marshal.SizeOf&<TRecord>);
    end;
    
    {$endregion Read}
    
    {$region Fill}
    
    ///- function PatternFill(ptr: IntPtr): BufferCommandQueue;
    ///Заполняет весь буфер копиями массива байт, длинной pattern_len,
    ///прочитанным из области оперативной памяти, на которую указывает ptr
    public function FillData(ptr: CommandQueue<IntPtr>; pattern_len: CommandQueue<integer>): Buffer;
    ///- function PatternFill(ptr: IntPtr; offset, len: integer): BufferCommandQueue;
    ///Заполняет часть буфера (начиная с байта №offset и длинной len) копиями массива байт, длинной pattern_len,
    ///прочитанным из области оперативной памяти, на которую указывает ptr
    public function FillData(ptr: CommandQueue<IntPtr>; pattern_len, offset, len: CommandQueue<integer>): Buffer;
    
    ///- function PatternFill(ptr: pointer): BufferCommandQueue;
    ///Заполняет весь буфер копиями массива байт, длинной pattern_len,
    ///прочитанным из области оперативной памяти, на которую указывает ptr
    public function FillData(ptr: pointer; pattern_len: CommandQueue<integer>) := FillData(IntPtr(ptr), pattern_len);
    ///- function PatternFill(ptr: pointer; offset, len: integer): BufferCommandQueue;
    ///Заполняет часть буфера (начиная с байта №offset и длинной len) копиями массива байт, длинной pattern_len,
    ///прочитанным из области оперативной памяти, на которую указывает ptr
    public function FillData(ptr: pointer; pattern_len, offset, len: CommandQueue<integer>) := FillData(IntPtr(ptr), pattern_len, offset, len);
    
    ///- function PatternFill(a: Array): BufferCommandQueue;
    ///Заполняет весь буфер копиями содержимого массива
    public function FillArray(a: CommandQueue<&Array>): Buffer;
    ///- function PatternFill(a: Array; offset, len: integer): BufferCommandQueue;
    ///Заполняет часть буфера (начиная с байта №offset и длинной len) копиями содержимого массива
    public function FillArray(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>): Buffer;
    
    ///- function PatternFill(a: Array): BufferCommandQueue;
    ///Заполняет весь буфер копиями содержимого массива
    public function FillArray(a: &Array) := FillArray(CommandQueue&<&Array>(a));
    ///- function PatternFill(a: Array; offset, len: integer): BufferCommandQueue;
    ///Заполняет часть буфера (начиная с байта №offset и длинной len) копиями содержимого массива
    public function FillArray(a: &Array; offset, len: CommandQueue<integer>) := FillArray(CommandQueue&<&Array>(a), offset, len);
    
    ///- function PatternFill<TRecord>(val: TRecord): BufferCommandQueue; where TRecord: record;
    ///Заполняет весь буфер копиями значения любого размерного типа
    public [MethodImpl(MethodImplOptions.AggressiveInlining)] function FillValue<TRecord>(val: TRecord): Buffer; where TRecord: record;
    ///- function PatternFill<TRecord>(val: TRecord; offset, len: integer): BufferCommandQueue; where TRecord: record;
    ///Заполняет часть буфера (начиная с байта №offset и длинной len) копиями значения любого размерного типа
    public [MethodImpl(MethodImplOptions.AggressiveInlining)] function FillValue<TRecord>(val: TRecord; offset, len: CommandQueue<integer>): Buffer; where TRecord: record;
    
    ///- function PatternFill<TRecord>(val: TRecord): BufferCommandQueue; where TRecord: record;
    ///Заполняет весь буфер копиями значения любого размерного типа
    public function FillValue<TRecord>(val: CommandQueue<TRecord>): Buffer; where TRecord: record;
    ///- function PatternFill<TRecord>(val: TRecord; offset, len: integer): BufferCommandQueue; where TRecord: record;
    ///Заполняет часть буфера (начиная с байта №offset и длинной len) копиями значения любого размерного типа
    public function FillValue<TRecord>(val: CommandQueue<TRecord>; offset, len: CommandQueue<integer>): Buffer; where TRecord: record;
    
    {$endregion Fill}
    
    {$region Copy}
    
    ///- function CopyFrom(b: Buffer; from, &to, len: integer): BufferCommandQueue;
    ///Копирует содержимое буфера b в данный буфер
    ///from - отступ в буффере b
    ///to   - отступ в данном буффере
    ///len  - кол-во копируемых байт
    public function CopyFrom(b: CommandQueue<Buffer>; from, &to, len: CommandQueue<integer>): Buffer;
    ///- function CopyTo(b: Buffer; from, &to, len: integer): BufferCommandQueue;
    ///Копирует содержимое данного буфера в буфер b
    ///from - отступ в данном буффере
    ///to   - отступ в буффере b
    ///len  - кол-во копируемых байт
    public function CopyTo  (b: CommandQueue<Buffer>; from, &to, len: CommandQueue<integer>): Buffer;
    
    ///- function CopyFrom(b: Buffer): BufferCommandQueue;
    ///Копирует всё содержимое буфера b в данный буфер
    public function CopyFrom(b: CommandQueue<Buffer>): Buffer;
    ///- function CopyTo(b: Buffer): BufferCommandQueue;
    ///Копирует всё содержимое данного буфера в буфер b
    public function CopyTo  (b: CommandQueue<Buffer>): Buffer;
    
    {$endregion Copy}
    
    {$region Get}
    
    ///- function GetData(offset, len: integer): IntPtr;
    ///Выделяет неуправляемую область в памяти
    ///И копирует в неё len байт из данного буфера, начиная с байта №offset
    ///Обязательно вызовите Marshal.FreeHGlobal на полученном дескрипторе, после использования
    public function GetData(offset, len: CommandQueue<integer>): IntPtr;
    ///- function GetData: IntPtr;
    ///Выделяет неуправляемую область в памяти, одинакового размера с данным буфером
    ///И копирует в неё всё содержимое данного буфера
    ///Обязательно вызовите Marshal.FreeHGlobal на полученном дескрипторе, после использования
    public function GetData := GetData(0,integer(self.Size32));
    
    
    
    ///- function GetArrayAt<TArray>(offset: integer; params szs: array of integer): TArray; where TArray: &Array;
    ///Создаёт новый массив с размерностями szs
    ///И копирует в него, начиная с байта offset, достаточно байт чтоб заполнить весь массив
    public function GetArrayAt<TArray>(offset: CommandQueue<integer>; szs: CommandQueue<array of integer>): TArray; where TArray: &Array;
    ///- function GetArray<TArray>(params szs: array of integer): TArray; where TArray: &Array;
    ///Создаёт новый массив с размерностями szs
    ///И копирует в него достаточно байт чтоб заполнить весь массив
    public function GetArray<TArray>(szs: CommandQueue<array of integer>): TArray; where TArray: &Array;
    begin Result := GetArrayAt&<TArray>(0, szs); end;
    
    ///- function GetArrayAt<TArray>(offset: integer; params szs: array of integer): TArray; where TArray: &Array;
    ///Создаёт новый массив с размерностями szs
    ///И копирует в него, начиная с байта offset, достаточно байт чтоб заполнить весь массив
    public function GetArrayAt<TArray>(offset: CommandQueue<integer>; params szs: array of CommandQueue<integer>): TArray; where TArray: &Array;
    ///- function GetArray<TArray>(params szs: array of integer): TArray; where TArray: &Array;
    ///Создаёт новый массив с размерностями szs
    ///И копирует в него достаточно байт чтоб заполнить весь массив
    public function GetArray<TArray>(params szs: array of integer): TArray; where TArray: &Array;
    begin Result := GetArrayAt&<TArray>(0, CommandQueue&<array of integer>(szs)); end;
    
    
    ///- function GetArray1At<TRecord>(offset: integer; length: integer): array of TRecord; where TRecord: record;
    ///Создаёт новый 1-мерный массив, с length элементами типа TRecord
    ///И копирует в него, начиная с байта offset, достаточно байт чтоб заполнить весь массив
    public function GetArray1At<TRecord>(offset, length: CommandQueue<integer>): array of TRecord; where TRecord: record;
    begin Result := GetArrayAt&<array of TRecord>(offset, length); end;
    ///- function GetArray1<TRecord>(length: integer): array of TRecord; where TRecord: record;
    ///Создаёт новый 1-мерный массив, с length элементами типа TRecord
    ///И копирует в него достаточно байт чтоб заполнить весь массив
    public function GetArray1<TRecord>(length: CommandQueue<integer>): array of TRecord; where TRecord: record;
    begin Result := GetArrayAt&<array of TRecord>(0,length); end;
    
    ///- function GetArray1<TRecord>: array of TRecord; where TRecord: record;
    ///Создаёт новый 1-мерный массив, с максимальным кол-вом элементов типа TRecord
    ///И копирует в него достаточно байт чтоб заполнить весь массив
    public function GetArray1<TRecord>: array of TRecord; where TRecord: record;
    begin Result := GetArrayAt&<array of TRecord>(0, integer(sz.ToUInt32) div Marshal.SizeOf&<TRecord>); end;
    
    
    ///- function GetArray2At<TRecord>(offset: integer; length: integer): array[,] of TRecord; where TRecord: record;
    ///Создаёт новый 2-мерный массив, с length элементами типа TRecord
    ///И копирует в него, начиная с байта offset, достаточно байт чтоб заполнить весь массив
    public function GetArray2At<TRecord>(offset, length1, length2: CommandQueue<integer>): array[,] of TRecord; where TRecord: record;
    begin Result := GetArrayAt&<array[,] of TRecord>(offset, length1, length2); end;
    ///- function GetArray2<TRecord>(length: integer): array of TRecord; where TRecord: record;
    ///Создаёт новый 2-мерный массив, с length элементами типа TRecord
    ///И копирует в него достаточно байт чтоб заполнить весь массив
    public function GetArray2<TRecord>(length1, length2: CommandQueue<integer>): array[,] of TRecord; where TRecord: record;
    begin Result := GetArrayAt&<array[,] of TRecord>(0, length1, length2); end;
    
    
    ///- function GetArray3At<TRecord>(offset: integer; length: integer): array[,,] of TRecord; where TRecord: record;
    ///Создаёт новый 3-мерный массив, с length элементами типа TRecord
    ///И копирует в него, начиная с байта offset, достаточно байт чтоб заполнить весь массив
    public function GetArray3At<TRecord>(offset, length1, length2, length3: CommandQueue<integer>): array[,,] of TRecord; where TRecord: record;
    begin Result := GetArrayAt&<array[,,] of TRecord>(offset, length1, length2, length3); end;
    ///- function GetArray3<TRecord>(length: integer): array[,,] of TRecord; where TRecord: record;
    ///Создаёт новый 3-мерный массив, с length элементами типа TRecord
    ///И копирует в него достаточно байт чтоб заполнить весь массив
    public function GetArray3<TRecord>(length1, length2, length3: CommandQueue<integer>): array[,,] of TRecord; where TRecord: record;
    begin Result := GetArrayAt&<array[,,] of TRecord>(0, length1, length2, length3); end;
    
    
    
    ///- function GetValueAt<TRecord>(offset: integer): TRecord; where TRecord: record;
    ///Читает значение любого размерного типа из данного буфера
    ///С отступом в offset байт в буфере
    public [MethodImpl(MethodImplOptions.AggressiveInlining)] function GetValueAt<TRecord>(offset: CommandQueue<integer>): TRecord; where TRecord: record;
    ///- function GetValue<TRecord>: TRecord; where TRecord: record;
    ///Читает значение любого размерного типа из начала данного буфера
    public [MethodImpl(MethodImplOptions.AggressiveInlining)] function GetValue<TRecord>: TRecord; where TRecord: record; begin Result := GetValueAt&<TRecord>(0); end;
    
    {$endregion Get}
    
    ///Высвобождает выделенную на GPU память
    ///Если такой нету - не делает ничего
    ///Память будет заново выделена, если снова использовать данный буфер
    public procedure Dispose :=
    if self.memobj<>cl_mem.Zero then
    begin
      cl.ReleaseMemObject(memobj);
      memobj := cl_mem.Zero;
    end;
    
    ///--
    public procedure Finalize; override :=
    self.Dispose;
    
  end;
  
  {$endregion Buffer}
  
  {$region Kernel}
  
  KernelCommandQueue=class;
  
  ///--
  KernelCommand = class
    protected ev: cl_event;
    
    protected procedure ClearEvent :=
    if self.ev<>cl_event.Zero then cl.ReleaseEvent(self.ev).RaiseIfError;
    
    protected function Invoke(kq: Kernel; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; abstract;
    
    protected procedure UnInvoke; abstract;
    
  end;
  
  ///--
  KernelCommandQueue = class(CommandQueue<Kernel>)
    protected commands := new List<KernelCommand>;
    
    {$region constructor's}
    
    protected constructor(org: Kernel) :=
    self.res := org;
    
    protected function AddCommand(comm: KernelCommand): KernelCommandQueue;
    begin
      self.commands += comm;
      Result := self;
    end;
    
    {$endregion constructor's}
    
    {$region AddQueue}
    
    public function AddQueue<T>(q: CommandQueue<T>): KernelCommandQueue;
    
    {$endregion AddQueue}
    
    {$region Exec}
    
    public function AddExec(work_szs: array of UIntPtr; params args: array of CommandQueue<Buffer>): KernelCommandQueue;
    public function AddExec(work_szs: array of integer; params args: array of CommandQueue<Buffer>) :=
    AddExec(work_szs.ConvertAll(sz->new UIntPtr(sz)), args);
    
    public function AddExec1(work_sz1: UIntPtr; params args: array of CommandQueue<Buffer>) := AddExec(new UIntPtr[](work_sz1), args);
    public function AddExec1(work_sz1: integer; params args: array of CommandQueue<Buffer>) := AddExec1(new UIntPtr(work_sz1), args);
    
    public function AddExec2(work_sz1, work_sz2: UIntPtr; params args: array of CommandQueue<Buffer>) := AddExec(new UIntPtr[](work_sz1, work_sz2), args);
    public function AddExec2(work_sz1, work_sz2: integer; params args: array of CommandQueue<Buffer>) := AddExec2(new UIntPtr(work_sz1), new UIntPtr(work_sz2), args);
    
    public function AddExec3(work_sz1, work_sz2, work_sz3: UIntPtr; params args: array of CommandQueue<Buffer>) := AddExec(new UIntPtr[](work_sz1, work_sz2, work_sz3), args);
    public function AddExec3(work_sz1, work_sz2, work_sz3: integer; params args: array of CommandQueue<Buffer>) := AddExec3(new UIntPtr(work_sz1), new UIntPtr(work_sz2), new UIntPtr(work_sz3), args);
    
    
    public function AddExec(work_szs: array of CommandQueue<UIntPtr>; params args: array of CommandQueue<Buffer>): KernelCommandQueue;
    public function AddExec(work_szs: array of CommandQueue<integer>; params args: array of CommandQueue<Buffer>) :=
    AddExec(work_szs.ConvertAll(sz_q->sz_q.ThenConvert(sz->new UIntPtr(sz))), args);
    
    public function AddExec1(work_sz1: CommandQueue<UIntPtr>; params args: array of CommandQueue<Buffer>) := AddExec(new CommandQueue<UIntPtr>[](work_sz1), args);
    public function AddExec1(work_sz1: CommandQueue<integer>; params args: array of CommandQueue<Buffer>) := AddExec1(work_sz1.ThenConvert(sz->new UIntPtr(sz)), args);
    
    public function AddExec2(work_sz1, work_sz2: CommandQueue<UIntPtr>; params args: array of CommandQueue<Buffer>) := AddExec(new CommandQueue<UIntPtr>[](work_sz1, work_sz2), args);
    public function AddExec2(work_sz1, work_sz2: CommandQueue<integer>; params args: array of CommandQueue<Buffer>) := AddExec2(work_sz1.ThenConvert(sz->new UIntPtr(sz)), work_sz2.ThenConvert(sz->new UIntPtr(sz)), args);
    
    public function AddExec3(work_sz1, work_sz2, work_sz3: CommandQueue<UIntPtr>; params args: array of CommandQueue<Buffer>) := AddExec(new CommandQueue<UIntPtr>[](work_sz1, work_sz2, work_sz3), args);
    public function AddExec3(work_sz1, work_sz2, work_sz3: CommandQueue<integer>; params args: array of CommandQueue<Buffer>) := AddExec3(work_sz1.ThenConvert(sz->new UIntPtr(sz)), work_sz2.ThenConvert(sz->new UIntPtr(sz)), work_sz3.ThenConvert(sz->new UIntPtr(sz)), args);
    
    
    public function AddExec(work_szs: CommandQueue<array of UIntPtr>; params args: array of CommandQueue<Buffer>): KernelCommandQueue;
    public function AddExec(work_szs: CommandQueue<array of integer>; params args: array of CommandQueue<Buffer>): KernelCommandQueue;
    
    {$endregion Exec}
    
    {$region reintroduce методы}
    
    private function Equals(obj: object): boolean; reintroduce := false;
    
    private function ToString: string; reintroduce := nil;
    
    private function GetType: System.Type; reintroduce := nil;
    
    private function GetHashCode: integer; reintroduce := 0;
    
    {$endregion reintroduce методы}
    
    protected function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      MakeBusy;
      
      foreach var comm in commands do
      begin
        yield sequence comm.Invoke(res, c, cq, prev_ev);
        prev_ev := comm.ev;
      end;
      
      self.ev := prev_ev;
    end;
    
    protected procedure UnInvoke; override;
    begin
      inherited;
      foreach var comm in commands do comm.UnInvoke;
    end;
    
  end;
  
  Kernel = sealed class
    private _kernel: cl_kernel;
    
    {$region constructor's}
    
    private constructor := raise new System.NotSupportedException;
    
    public constructor(prog: ProgramCode; name: string);
    
    {$endregion constructor's}
    
    {$region Queue's}
    
    public function NewQueue :=
    new KernelCommandQueue(self);
    
    {$endregion Queue's}
    
    {$region Exec}
    
    public function Exec(work_szs: array of UIntPtr; params args: array of CommandQueue<Buffer>): Kernel;
    public function Exec(work_szs: array of integer; params args: array of CommandQueue<Buffer>) :=
    Exec(work_szs.ConvertAll(sz->new UIntPtr(sz)), args);
    
    public function Exec1(work_sz1: UIntPtr; params args: array of CommandQueue<Buffer>) := Exec(new UIntPtr[](work_sz1), args);
    public function Exec1(work_sz1: integer; params args: array of CommandQueue<Buffer>) := Exec1(new UIntPtr(work_sz1), args);
    
    public function Exec2(work_sz1, work_sz2: UIntPtr; params args: array of CommandQueue<Buffer>) := Exec(new UIntPtr[](work_sz1, work_sz2), args);
    public function Exec2(work_sz1, work_sz2: integer; params args: array of CommandQueue<Buffer>) := Exec2(new UIntPtr(work_sz1), new UIntPtr(work_sz2), args);
    
    public function Exec3(work_sz1, work_sz2, work_sz3: UIntPtr; params args: array of CommandQueue<Buffer>) := Exec(new UIntPtr[](work_sz1, work_sz2, work_sz3), args);
    public function Exec3(work_sz1, work_sz2, work_sz3: integer; params args: array of CommandQueue<Buffer>) := Exec3(new UIntPtr(work_sz1), new UIntPtr(work_sz2), new UIntPtr(work_sz3), args);
    
    
    public function Exec(work_szs: array of CommandQueue<UIntPtr>; params args: array of CommandQueue<Buffer>): Kernel;
    public function Exec(work_szs: array of CommandQueue<integer>; params args: array of CommandQueue<Buffer>) :=
    Exec(work_szs.ConvertAll(sz_q->sz_q.ThenConvert(sz->new UIntPtr(sz))), args);
    
    public function Exec1(work_sz1: CommandQueue<UIntPtr>; params args: array of CommandQueue<Buffer>) := Exec(new CommandQueue<UIntPtr>[](work_sz1), args);
    public function Exec1(work_sz1: CommandQueue<integer>; params args: array of CommandQueue<Buffer>) := Exec1(work_sz1.ThenConvert(sz->new UIntPtr(sz)), args);
    
    public function Exec2(work_sz1, work_sz2: CommandQueue<UIntPtr>; params args: array of CommandQueue<Buffer>) := Exec(new CommandQueue<UIntPtr>[](work_sz1, work_sz2), args);
    public function Exec2(work_sz1, work_sz2: CommandQueue<integer>; params args: array of CommandQueue<Buffer>) := Exec2(work_sz1.ThenConvert(sz->new UIntPtr(sz)), work_sz2.ThenConvert(sz->new UIntPtr(sz)), args);
    
    public function Exec3(work_sz1, work_sz2, work_sz3: CommandQueue<UIntPtr>; params args: array of CommandQueue<Buffer>) := Exec(new CommandQueue<UIntPtr>[](work_sz1, work_sz2, work_sz3), args);
    public function Exec3(work_sz1, work_sz2, work_sz3: CommandQueue<integer>; params args: array of CommandQueue<Buffer>) := Exec3(work_sz1.ThenConvert(sz->new UIntPtr(sz)), work_sz2.ThenConvert(sz->new UIntPtr(sz)), work_sz3.ThenConvert(sz->new UIntPtr(sz)), args);
    
    
    public function Exec(work_szs: CommandQueue<array of UIntPtr>; params args: array of CommandQueue<Buffer>): Kernel;
    public function Exec(work_szs: CommandQueue<array of integer>; params args: array of CommandQueue<Buffer>): Kernel;
    
    {$endregion Exec}
    
    public procedure Finalize; override :=
    cl.ReleaseKernel(self._kernel).RaiseIfError;
    
  end;
  
  {$endregion Kernel}
  
  {$region Context}
  
  Context = sealed class
    private static _platform: cl_platform_id;
    private static _def_cont: Context;
    
    private _device: cl_device_id;
    private _context: cl_context;
    private need_finnalize := false;
    
    public static property &Default: Context read _def_cont write _def_cont;
    
    static constructor :=
    try
      
      var ec := cl.GetPlatformIDs(1,@_platform,nil);
      ec.RaiseIfError;
      
      try
        _def_cont := new Context;
      except
        _def_cont := new Context(DeviceTypeFlags.All); // если нету GPU - попытаться хотя бы для чего то его инициализировать
      end;
      
    except
      on e: Exception do
      begin
        {$reference PresentationFramework.dll}
        System.Windows.MessageBox.Show(e.ToString, 'Не удалось инициализировать OpenCL');
        Halt;
      end;
    end;
    
    /// Инициализирует новый контекст c 1 девайсом типа GPU
    public constructor := Create(DeviceTypeFlags.GPU);
    
    /// Инициализирует новый контекст c 1 девайсом типа dt
    public constructor(dt: DeviceTypeFlags);
    begin
      var ec: ErrorCode;
      
      cl.GetDeviceIDs(_platform, dt, 1, @_device, nil).RaiseIfError;
      
      _context := cl.CreateContext(nil, 1, @_device, nil, nil, @ec);
      ec.RaiseIfError;
      
      need_finnalize := true;
    end;
    
    /// Создаёт обёртку для дескриптора контекста, полученного модулем OpenCL
    /// Девайс выбирается первый попавшейся из списка связанных
    /// Автоматическое удаление контекста не произойдёт при удалении всех ссылок на полученную обёртку
    /// В отличии от создания нового контекста - контекстом управляет модуль OpenCL а не OpenCLABC
    public constructor(context: cl_context);
    begin
      
      cl.GetContextInfo(context, ContextInfoType.CL_CONTEXT_DEVICES, new UIntPtr(IntPtr.Size), @_device, nil).RaiseIfError;
      
      _context := context;
    end;
    
    /// Создаёт обёртку для дескриптора контекста, полученного модулем OpenCL
    /// Девайс выбирается с указанным дескриптором, так же полученный из модуля OpenCL
    /// Автоматическое удаление контекста не произойдёт при удалении всех ссылок на полученную обёртку
    /// В отличии от создания нового контекста - контекстом управляет модуль OpenCL а не OpenCLABC
    public constructor(context: cl_context; device: cl_device_id);
    begin
      _device := device;
      _context := context;
    end;
    
    /// Инициализирует все команды в очереди и запускает первые
    /// Возвращает объект задачи, по которому можно следить за состоянием выполнения очереди
    public function BeginInvoke<T>(q: CommandQueue<T>): Task<T>;
    begin
      var ec: ErrorCode;
      var cq := cl.CreateCommandQueue(_context, _device, CommandQueuePropertyFlags.QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE, ec);
      ec.RaiseIfError;
      
      var tasks := q.Invoke(self, cq, cl_event.Zero).ToList;
      
      var костыль_для_Result: ()->T := ()-> //ToDo #1952
      try
        while true do
        begin
          for var i := tasks.Count-1 downto 0 do
            if tasks[i].Status <> TaskStatus.Running then
            begin
              if tasks[i].Exception<>nil then raise tasks[i].Exception;
              tasks.RemoveAt(i);
            end;
          if tasks.Count=0 then break;
          Sleep(10);
        end;
        if q.ev<>cl_event.Zero then cl.WaitForEvents(1, @q.ev).RaiseIfError;
        
        cl.ReleaseCommandQueue(cq).RaiseIfError;
        Result := q.res;
      finally
        q.UnInvoke;
      end;
      
      Result := Task.Run(костыль_для_Result);
    end;
    
    /// Выполняет BeginInvoke и ожидает окончания выполнения возвращённой задачи
    /// Возвращает результат задачи, который, обычно, ничего не означает
    public function SyncInvoke<T>(q: CommandQueue<T>): T;
    begin
      var tsk := BeginInvoke(q);
      tsk.Wait;
      Result := tsk.Result;
    end;
    
    ///--
    public procedure Finalize; override :=
    if need_finnalize then // если было исключение при инициализации или инициализация произошла из дескриптора
      cl.ReleaseContext(_context).RaiseIfError;
    
  end;
  
  {$endregion Context}
  
  {$region ProgramCode}
  
  ProgramCode = sealed class
    private _program: cl_program;
    private cntxt: Context;
    
    private constructor := exit;
    
    public constructor(c: Context; params files_texts: array of string);
    begin
      var ec: ErrorCode;
      self.cntxt := c;
      
      self._program := cl.CreateProgramWithSource(c._context, files_texts.Length, files_texts, files_texts.ConvertAll(s->new UIntPtr(s.Length)), ec);
      ec.RaiseIfError;
      
      cl.BuildProgram(self._program, 1, @c._device, nil,nil,nil).RaiseIfError;
      
    end;
    
    public constructor(params files_texts: array of string) :=
    Create(Context.Default, files_texts);
    
    public property KernelByName[kname: string]: Kernel read new Kernel(self, kname); default;
    
    public function GetAllKernels: Dictionary<string, Kernel>;
    begin
      
      var names_char_len: UIntPtr;
      cl.GetProgramInfo(_program, ProgramInfoType.NUM_KERNELS, new UIntPtr(UIntPtr.Size), @names_char_len, nil).RaiseIfError;
      
      var names_ptr := Marshal.AllocHGlobal(IntPtr(pointer(names_char_len))+1);
      cl.GetProgramInfo(_program, ProgramInfoType.KERNEL_NAMES, names_char_len, pointer(names_ptr), nil).RaiseIfError;
      
      var names := Marshal.PtrToStringAnsi(names_ptr).Split(';');
      Marshal.FreeHGlobal(names_ptr);
      
      Result := new Dictionary<string, Kernel>(names.Length);
      foreach var kname in names do
        Result[kname] := self[kname];
      
    end;
    
    public function Serialize: array of byte;
    begin
      var bytes_count: UIntPtr;
      cl.GetProgramInfo(_program, ProgramInfoType.BINARY_SIZES, new UIntPtr(UIntPtr.Size), @bytes_count, nil).RaiseIfError;
      
      var bytes_mem := Marshal.AllocHGlobal(IntPtr(pointer(bytes_count)));
      cl.GetProgramInfo(_program, ProgramInfoType.BINARIES, bytes_count, @bytes_mem, nil).RaiseIfError;
      
      Result := new byte[bytes_count.ToUInt64()];
      Marshal.Copy(bytes_mem,Result, 0,Result.Length);
      Marshal.FreeHGlobal(bytes_mem);
      
    end;
    
    public procedure SerializeTo(bw: System.IO.BinaryWriter);
    begin
      var bts := Serialize;
      bw.Write(bts.Length);
      bw.Write(bts);
    end;
    
    public procedure SerializeTo(str: System.IO.Stream) := SerializeTo(new System.IO.BinaryWriter(str));
    
    public static function Deserialize(c: Context; bin: array of byte): ProgramCode;
    begin
      var ec: ErrorCode;
      
      Result := new ProgramCode;
      Result.cntxt := c;
      
      var gchnd := GCHandle.Alloc(bin, GCHandleType.Pinned);
      var bin_mem: ^byte := pointer(gchnd.AddrOfPinnedObject);
      var bin_len := new UIntPtr(bin.Length);
      
      Result._program := cl.CreateProgramWithBinary(c._context,1,@c._device, @bin_len, @bin_mem, nil, @ec);
      ec.RaiseIfError;
      gchnd.Free;
      
    end;
    
    public static function DeserializeFrom(c: Context; br: System.IO.BinaryReader): ProgramCode;
    begin
      var bin_len := br.ReadInt32;
      var bin_arr := br.ReadBytes(bin_len);
      if bin_arr.Length<bin_len then raise new System.IO.EndOfStreamException;
      Result := Deserialize(c, bin_arr);
    end;
    
    public static function DeserializeFrom(c: Context; str: System.IO.Stream) :=
    DeserializeFrom(c, new System.IO.BinaryReader(str));
    
  end;
  
  {$endregion ProgramCode}
  
{$region Сахарные подпрограммы}

///Host Funcion Queue
///Создаёт новую очередь, выполняющую функцию на CPU
function HFQ<T>(f: ()->T): CommandQueue<T>;

///Host Procecure Queue
///Создаёт новую очередь, выполняющую процедуру на CPU
function HPQ(p: ()->()): CommandQueue<object>;

///Складывает все очереди qs
///Возвращает очередь, по очереди выполняющую все очереди из qs
function CombineSyncQueue<T>(qs: List<CommandQueueBase>): CommandQueue<T>;
///Складывает все очереди qs
///Возвращает очередь, по очереди выполняющую все очереди из qs
function CombineSyncQueue<T>(qs: List<CommandQueue<T>>): CommandQueue<T>;
///Складывает все очереди qs
///Возвращает очередь, по очереди выполняющую все очереди из qs
function CombineSyncQueue<T>(params qs: array of CommandQueueBase): CommandQueue<T>;
///Складывает все очереди qs
///Возвращает очередь, по очереди выполняющую все очереди из qs
function CombineSyncQueue<T>(params qs: array of CommandQueue<T>): CommandQueue<T>;
///Складывает все очереди qs
///Возвращает очередь, по очереди выполняющую все очереди из qs
///И затем применяет преобразование conv чтоб получить из результатов очередей qs - свой результат
function CombineSyncQueue<T,TRes>(conv: Func<array of object, TRes>; qs: List<CommandQueueBase>): CommandQueue<TRes>;
///Складывает все очереди qs
///Возвращает очередь, по очереди выполняющую все очереди из qs
///И затем применяет преобразование conv чтоб получить из результатов очередей qs - свой результат
function CombineSyncQueue<T,TRes>(conv: Func<array of T, TRes>; qs: List<CommandQueue<T>>): CommandQueue<TRes>;
///Складывает все очереди qs
///Возвращает очередь, по очереди выполняющую все очереди из qs
///И затем применяет преобразование conv чтоб получить из результатов очередей qs - свой результат
function CombineSyncQueue<T,TRes>(conv: Func<array of object, TRes>; params qs: array of CommandQueueBase): CommandQueue<TRes>;
///Складывает все очереди qs
///Возвращает очередь, по очереди выполняющую все очереди из qs
///И затем применяет преобразование conv чтоб получить из результатов очередей qs - свой результат
function CombineSyncQueue<T,TRes>(conv: Func<array of T, TRes>; params qs: array of CommandQueue<T>): CommandQueue<TRes>;

///Умножает все очереди qs
///Возвращает очередь, параллельно выполняющую все очереди из qs
function CombineAsyncQueue<T>(qs: List<CommandQueueBase>): CommandQueue<T>;
///Умножает все очереди qs
///Возвращает очередь, параллельно выполняющую все очереди из qs
function CombineAsyncQueue<T>(qs: List<CommandQueue<T>>): CommandQueue<T>;
///Умножает все очереди qs
///Возвращает очередь, параллельно выполняющую все очереди из qs
function CombineAsyncQueue<T>(params qs: array of CommandQueueBase): CommandQueue<T>;
///Умножает все очереди qs
///Возвращает очередь, параллельно выполняющую все очереди из qs
function CombineAsyncQueue<T>(params qs: array of CommandQueue<T>): CommandQueue<T>;
///Умножает все очереди qs
///Возвращает очередь, параллельно выполняющую все очереди из qs
///И затем применяет преобразование conv чтоб получить из результатов очередей qs - свой результат
function CombineAsyncQueue<T,TRes>(conv: Func<array of object, TRes>; qs: List<CommandQueueBase>): CommandQueue<TRes>;
///Умножает все очереди qs
///Возвращает очередь, параллельно выполняющую все очереди из qs
///И затем применяет преобразование conv чтоб получить из результатов очередей qs - свой результат
function CombineAsyncQueue<T,TRes>(conv: Func<array of T, TRes>; qs: List<CommandQueue<T>>): CommandQueue<TRes>;
///Умножает все очереди qs
///Возвращает очередь, параллельно выполняющую все очереди из qs
///И затем применяет conv чтоб получить из результатов очередей qs - свой результат
///И затем применяет преобразование conv чтоб получить из результатов очередей qs - свой результат
function CombineAsyncQueue<T,TRes>(conv: Func<array of object, TRes>; params qs: array of CommandQueueBase): CommandQueue<TRes>;
///Умножает все очереди qs
///Возвращает очередь, параллельно выполняющую все очереди из qs
///И затем применяет преобразование conv чтоб получить из результатов очередей qs - свой результат
function CombineAsyncQueue<T,TRes>(conv: Func<array of T, TRes>; params qs: array of CommandQueue<T>): CommandQueue<TRes>;

{$endregion Сахарные подпрограммы}

implementation

{$region CommandQueue}

{$region HostFunc}

type
  CommandQueueHostFunc<T> = sealed class(CommandQueue<T>)
    private f: ()->T;
    
    public constructor(f: ()->T) :=
    self.f := f;
    
    public constructor(o: T);
    begin
      self.res := o;
      self.f := nil;
    end;
    
    protected function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  
function CommandQueueHostFunc<T>.Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task;
begin
  var ec: ErrorCode;
  MakeBusy;
  
  if (prev_ev<>cl_event.Zero) or (self.f <> nil) then
  begin
    
    ClearEvent;
    self.ev := cl.CreateUserEvent(c._context, ec);
    ec.RaiseIfError;
    
    yield Task.Run(()->
    begin
      if prev_ev<>cl_event.Zero then cl.WaitForEvents(1,@prev_ev).RaiseIfError;
      if self.f<>nil then self.res := self.f();
      
      cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
    end);
    
  end else
    self.ev := cl_event.Zero;
  
end;

static function CommandQueue<T>.operator implicit(o: T): CommandQueue<T> :=
new CommandQueueHostFunc<T>(o);

{$endregion HostFunc}

{$region Multiusable}

type
  MutiusableCommandQueueNode<T>=class;
  
  // invoke_status:
  // 0 - выполнение не начато
  // 1 - выполнение начинается
  // 3 - выполнение прекращается
  
  MutiusableCommandQueueHub<T> = class
    
    public q: CommandQueue<T>;
    public q_task: Task;
    
    public invoke_status := 0;
    public invoked_count := 0;
    
    public constructor(q: CommandQueue<T>) :=
    self.q := q;
    
    public function OnNodeInvoked(c: Context; cq: cl_command_queue): sequence of Task;
    public procedure OnNodeUnInvoked;
    
  end;
  
  MutiusableCommandQueueNode<T> = sealed class(CommandQueue<T>)
    public hub: MutiusableCommandQueueHub<T>;
    
    public constructor(hub: MutiusableCommandQueueHub<T>) :=
    self.hub := hub;
    
    public function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      MakeBusy;
      
      yield sequence hub.OnNodeInvoked(c,cq);
      
      ClearEvent;
      self.ev := cl.CreateUserEvent(c._context, ec);
      ec.RaiseIfError;
      
      yield Task.Run(()->
      begin
        if hub.q_task<>nil then hub.q_task.Wait;
        self.res := hub.q.res;
        cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
      end);
      
    end;
    
    public procedure UnInvoke; override;
    begin
      inherited;
      hub.OnNodeUnInvoked;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  
//ToDo почему то нет точки сворачивания, разобраться
function MutiusableCommandQueueHub<T>.OnNodeInvoked(c: Context; cq: cl_command_queue): sequence of Task;
begin
  case invoke_status of
    0: invoke_status := 1;
    2: raise new QueueDoubleInvokeException;
  end;
  
  if invoked_count=0 then
  begin
    Result := q.Invoke(c,cq, cl_event.Zero);
    q_task := q.ev=cl_event.Zero ? nil : Task.Run(()->cl.WaitForEvents(1,@q.ev).RaiseIfError());
  end else
    Result := System.Linq.Enumerable.Empty&<Task>;
  
  invoked_count += 1;
  
end;

procedure MutiusableCommandQueueHub<T>.OnNodeUnInvoked;
begin
  case invoke_status of
    //0: raise new InvalidOperationException('Ошибка внутри модуля OpenCLABC: совершена попыта завершить не запущенную очередь. Сообщите, пожалуйста, разработчику OpenCLABC');
    1: invoke_status := 2;
  end;
  
  invoked_count -= 1;
  if invoked_count=0 then
  begin
    invoke_status := 0;
    q_task := nil;
    q.UnInvoke;
  end;
  
end;

function CommandQueue<T>.Multiusable(n: integer): array of CommandQueue<T>;
begin
  var hub := new MutiusableCommandQueueHub<T>(self);
  Result := ArrGen(n, i->new MutiusableCommandQueueNode<T>(hub) as CommandQueue<T>);
end;

{$endregion Multiusable}

{$region ThenConvert}

type
  CommandQueueResConvertor<T1,T2> = sealed class(CommandQueue<T2>)
    q: CommandQueue<T1>;
    f: T1->T2;
    
    constructor(q: CommandQueue<T1>; f: T1->T2);
    begin
      self.q := q;
      self.f := f;
    end;
    
    protected function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      MakeBusy;
      
      yield sequence q.Invoke(c, cq, prev_ev);
      
      ClearEvent;
      self.ev := cl.CreateUserEvent(c._context, ec);
      ec.RaiseIfError;
      
      yield Task.Run(()->
      begin
        if q.ev<>cl_event.Zero then cl.WaitForEvents(1,@q.ev).RaiseIfError;
        self.res := self.f(q.res);
        
        cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
      end);
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      inherited;
      q.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  
function CommandQueue<T>.ThenConvert<T2>(f: T->T2) :=
new CommandQueueResConvertor<T,T2>(self, f);

{$endregion ThenConvert}

{$region SyncList}

//ToDo лучше всё же хранить массив а не список... И для Async тоже

type
  CommandQueueSyncList<T> = sealed class(CommandQueue<T>)
    public lst: List<CommandQueueBase>;
    
    public constructor :=
    lst := new List<CommandQueueBase>;
    
    public constructor(qs: List<CommandQueueBase>) :=
    lst := qs;
    
    public constructor(qs: array of CommandQueueBase) :=
    lst := qs.ToList;
    
    protected function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      MakeBusy;
      
      foreach var sq in lst do
      begin
        yield sequence sq.Invoke(c, cq, prev_ev);
        prev_ev := sq.ev;
      end;
      
      if prev_ev<>cl_event.Zero then
      begin
        ClearEvent;
        self.ev := cl.CreateUserEvent(c._context, ec);
        ec.RaiseIfError;
        
        yield Task.Run(()->
        begin
          cl.WaitForEvents(1,@prev_ev).RaiseIfError;
          self.res := T(lst[lst.Count-1].GetRes);
          cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
        end);
      end else
      begin
        self.res := T(lst[lst.Count-1].GetRes);
        self.ev := cl_event.Zero;
      end;
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      inherited;
      foreach var q in lst do q.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  CommandQueueTSyncList<T> = sealed class(CommandQueue<T>)
    public lst: List<CommandQueue<T>>;
    
    public constructor :=
    lst := new List<CommandQueue<T>>;
    
    public constructor(qs: List<CommandQueue<T>>) :=
    lst := qs;
    
    public constructor(qs: array of CommandQueue<T>) :=
    lst := qs.ToList;
    
    protected function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      MakeBusy;
      
      foreach var sq in lst do
      begin
        yield sequence sq.Invoke(c, cq, prev_ev);
        prev_ev := sq.ev;
      end;
      
      if prev_ev<>cl_event.Zero then
      begin
        ClearEvent;
        self.ev := cl.CreateUserEvent(c._context, ec);
        ec.RaiseIfError;
        
        yield Task.Run(()->
        begin
          cl.WaitForEvents(1,@prev_ev).RaiseIfError;
          self.res := lst[lst.Count-1].res;
          cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
        end);
      end else
      begin
        self.res := lst[lst.Count-1].res;
        self.ev := cl_event.Zero;
      end;
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      inherited;
      foreach var q in lst do q.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  CommandQueueCSyncList<TRes> = sealed class(CommandQueue<TRes>)
    public lst: List<CommandQueueBase>;
    public conv: Func<array of object,TRes>;
    
    public constructor :=
    lst := new List<CommandQueueBase>;
    
    public constructor(qs: List<CommandQueueBase>; conv: Func<array of object,TRes>);
    begin
      self.lst := qs;
      self.conv := conv;
    end;
    
    public constructor(qs: array of CommandQueueBase; conv: Func<array of object,TRes>);
    begin
      self.lst := qs.ToList;
      self.conv := conv;
    end;
    
    protected function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      MakeBusy;
      
      foreach var sq in lst do
      begin
        yield sequence sq.Invoke(c, cq, prev_ev);
        prev_ev := sq.ev;
      end;
      
      if prev_ev<>cl_event.Zero then
      begin
        ClearEvent;
        self.ev := cl.CreateUserEvent(c._context, ec);
        ec.RaiseIfError;
        
        yield Task.Run(()->
        begin
          cl.WaitForEvents(1,@prev_ev).RaiseIfError;
          
          var a := new object[lst.Count];
          for var i := 0 to lst.Count-1 do a[i] := lst[i].GetRes;
          self.res := conv(a);
          
          cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
        end);
      end else
      begin
        
        var a := new object[lst.Count];
        for var i := 0 to lst.Count-1 do a[i] := lst[i].GetRes;
        self.res := conv(a);
        
        self.ev := cl_event.Zero;
      end;
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      inherited;
      foreach var q in lst do q.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  CommandQueueCTSyncList<T,TRes> = sealed class(CommandQueue<TRes>)
    public lst: List<CommandQueue<T>>;
    public conv: Func<array of T,TRes>;
    
    public constructor :=
    lst := new List<CommandQueue<T>>;
    
    public constructor(qs: List<CommandQueue<T>>; conv: Func<array of T,TRes>);
    begin
      self.lst := qs;
      self.conv := conv;
    end;
    
    public constructor(qs: array of CommandQueue<T>; conv: Func<array of T,TRes>);
    begin
      self.lst := qs.ToList;
      self.conv := conv;
    end;
    
    protected function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      MakeBusy;
      
      foreach var sq in lst do
      begin
        yield sequence sq.Invoke(c, cq, prev_ev);
        prev_ev := sq.ev;
      end;
      
      if prev_ev<>cl_event.Zero then
      begin
        ClearEvent;
        self.ev := cl.CreateUserEvent(c._context, ec);
        ec.RaiseIfError;
        
        yield Task.Run(()->
        begin
          cl.WaitForEvents(1,@prev_ev).RaiseIfError;
          
          var a := new T[lst.Count];
          for var i := 0 to lst.Count-1 do a[i] := lst[i].res;
          self.res := conv(a);
          
          cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
        end);
      end else
      begin
        
        var a := new T[lst.Count];
        for var i := 0 to lst.Count-1 do a[i] := lst[i].res;
        self.res := conv(a);
        
        self.ev := cl_event.Zero;
      end;
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      inherited;
      foreach var q in lst do q.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  
static function CommandQueue<T>.operator+<T2>(q1: CommandQueue<T>; q2: CommandQueue<T2>): CommandQueue<T2>;
begin
  var ql1 := q1 as CommandQueueSyncList<T>;
  var ql2 := q2 as CommandQueueSyncList<T2>;
  var qtl1 := q1 as CommandQueueTSyncList<T>;
  var qtl2 := q2 as CommandQueueTSyncList<T2>;
  
  if (typeof(T)=typeof(T2)) and (ql1=nil) and (ql2=nil) then
  begin
    var res := new CommandQueueTSyncList<T2>;
    
    if qtl1<>nil then
      res.lst.AddRange(qtl1.lst.Cast&<CommandQueue<T2>>) else
      res.lst += q1 as object as CommandQueue<T2>;
    
    if qtl2<>nil then
      res.lst.AddRange(qtl2.lst) else
      res.lst += q2;
    
    Result := res;
  end else
  begin
    var res: CommandQueueSyncList<T2>;
    
    if ql1<>nil then res.lst.AddRange(ql1.lst) else
    if qtl1<>nil then res.lst.AddRange(qtl1.lst.Cast&<CommandQueueBase>) else
      res.lst += q1 as CommandQueueBase;
    
    if ql2<>nil then res.lst.AddRange(ql2.lst) else
    if qtl2<>nil then res.lst.AddRange(qtl2.lst.Cast&<CommandQueueBase>) else
      res.lst += q2 as CommandQueueBase;
    
    Result := res;
  end;
  
end;

{$endregion SyncList}

{$region AsyncList}

type
  CommandQueueAsyncList<T> = sealed class(CommandQueue<T>)
    public lst: List<CommandQueueBase>;
    
    public constructor :=
    lst := new List<CommandQueueBase>;
    
    public constructor(qs: List<CommandQueueBase>) :=
    lst := qs;
    
    public constructor(qs: array of CommandQueueBase) :=
    lst := qs.ToList;
    
    protected function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      MakeBusy;
      
      foreach var sq in lst do yield sequence sq.Invoke(c, cq, prev_ev);
      var evs := lst.Select(q->q.ev).Where(ev->ev<>cl_event.Zero).ToList;
      
      if evs.Count<>0 then
      begin
        
        ClearEvent;
        self.ev := cl.CreateUserEvent(c._context, ec);
        ec.RaiseIfError;
        
        yield Task.Run(()->
        begin
          cl.WaitForEvents(evs.Count,evs.ToArray).RaiseIfError;
          self.res := T(lst[lst.Count-1].GetRes);
          cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
        end);
        
      end else
      begin
        self.res := T(lst[lst.Count-1].GetRes);
        self.ev := cl_event.Zero;
      end;
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      inherited;
      foreach var q in lst do q.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  CommandQueueTAsyncList<T> = sealed class(CommandQueue<T>)
    public lst: List<CommandQueue<T>>;
    
    public constructor :=
    lst := new List<CommandQueue<T>>;
    
    public constructor(qs: List<CommandQueue<T>>) :=
    lst := qs;
    
    public constructor(qs: array of CommandQueue<T>) :=
    lst := qs.ToList;
    
    protected function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      MakeBusy;
      
      foreach var sq in lst do yield sequence sq.Invoke(c, cq, prev_ev);
      var evs := lst.Select(q->q.ev).Where(ev->ev<>cl_event.Zero).ToList;
      
      if evs.Count<>0 then
      begin
        
        ClearEvent;
        self.ev := cl.CreateUserEvent(c._context, ec);
        ec.RaiseIfError;
        
        yield Task.Run(()->
        begin
          cl.WaitForEvents(evs.Count,evs.ToArray).RaiseIfError;
          self.res := lst[lst.Count-1].res;
          cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
        end);
        
      end else
      begin
        self.res := lst[lst.Count-1].res;
        self.ev := cl_event.Zero;
      end;
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      inherited;
      foreach var q in lst do q.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  CommandQueueCAsyncList<TRes> = sealed class(CommandQueue<TRes>)
    public lst: List<CommandQueueBase>;
    public conv: Func<array of object,TRes>;
    
    public constructor :=
    lst := new List<CommandQueueBase>;
    
    public constructor(qs: List<CommandQueueBase>; conv: Func<array of object,TRes>);
    begin
      self.lst := qs;
      self.conv := conv;
    end;
    
    public constructor(qs: array of CommandQueueBase; conv: Func<array of object,TRes>);
    begin
      self.lst := qs.ToList;
      self.conv := conv;
    end;
    
    protected function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      MakeBusy;
      
      foreach var sq in lst do yield sequence sq.Invoke(c, cq, prev_ev);
      var evs := lst.Select(q->q.ev).Where(ev->ev<>cl_event.Zero).ToList;
      
      if evs.Count<>0 then
      begin
        
        ClearEvent;
        self.ev := cl.CreateUserEvent(c._context, ec);
        ec.RaiseIfError;
        
        yield Task.Run(()->
        begin
          cl.WaitForEvents(evs.Count,evs.ToArray).RaiseIfError;
          
          var a := new object[lst.Count];
          for var i := 0 to lst.Count-1 do a[i] := lst[i].GetRes;
          self.res := conv(a);
          
          cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
        end);
        
      end else
      begin
        
        var a := new object[lst.Count];
        for var i := 0 to lst.Count-1 do a[i] := lst[i].GetRes;
        self.res := conv(a);
        
        self.ev := cl_event.Zero;
      end;
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      inherited;
      foreach var q in lst do q.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  CommandQueueCTAsyncList<T,TRes> = sealed class(CommandQueue<TRes>)
    public lst: List<CommandQueue<T>>;
    public conv: Func<array of T,TRes>;
    
    public constructor :=
    lst := new List<CommandQueue<T>>;
    
    public constructor(qs: List<CommandQueue<T>>; conv: Func<array of T,TRes>);
    begin
      self.lst := qs;
      self.conv := conv;
    end;
    
    public constructor(qs: array of CommandQueue<T>; conv: Func<array of T,TRes>);
    begin
      self.lst := qs.ToList;
      self.conv := conv;
    end;
    
    protected function Invoke(c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      MakeBusy;
      
      foreach var sq in lst do yield sequence sq.Invoke(c, cq, prev_ev);
      var evs := lst.Select(q->q.ev).Where(ev->ev<>cl_event.Zero).ToList;
      
      if evs.Count<>0 then
      begin
        
        ClearEvent;
        self.ev := cl.CreateUserEvent(c._context, ec);
        ec.RaiseIfError;
        
        yield Task.Run(()->
        begin
          cl.WaitForEvents(evs.Count,evs.ToArray).RaiseIfError;
          
          var a := new T[lst.Count];
          for var i := 0 to lst.Count-1 do a[i] := lst[i].res;
          self.res := conv(a);
          
          cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
        end);
        
      end else
      begin
        
        var a := new T[lst.Count];
        for var i := 0 to lst.Count-1 do a[i] := lst[i].res;
        self.res := conv(a);
        
        self.ev := cl_event.Zero;
      end;
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      inherited;
      foreach var q in lst do q.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  
static function CommandQueue<T>.operator*<T2>(q1: CommandQueue<T>; q2: CommandQueue<T2>): CommandQueue<T2>;
begin
  var ql1 := q1 as CommandQueueAsyncList<T>;
  var ql2 := q2 as CommandQueueAsyncList<T2>;
  var qtl1 := q1 as CommandQueueTAsyncList<T>;
  var qtl2 := q2 as CommandQueueTAsyncList<T2>;
  
  if (typeof(T)=typeof(T2)) and (ql1=nil) and (ql2=nil) then
  begin
    var res := new CommandQueueTAsyncList<T2>;
    
    if qtl1<>nil then
      res.lst.AddRange(qtl1.lst.Cast&<CommandQueue<T2>>) else
      res.lst += q1 as object as CommandQueue<T2>;
    
    if qtl2<>nil then
      res.lst.AddRange(qtl2.lst) else
      res.lst += q2;
    
    Result := res;
  end else
  begin
    var res: CommandQueueAsyncList<T2>;
    
    if ql1<>nil then res.lst.AddRange(ql1.lst) else
    if qtl1<>nil then res.lst.AddRange(qtl1.lst.Cast&<CommandQueueBase>) else
      res.lst += q1 as CommandQueueBase;
    
    if ql2<>nil then res.lst.AddRange(ql2.lst) else
    if qtl2<>nil then res.lst.AddRange(qtl2.lst.Cast&<CommandQueueBase>) else
      res.lst += q2 as CommandQueueBase;
    
    Result := res;
  end;
  
end;

{$endregion AsyncList}

{$region Buffer}

{$region AddQueue}

type
  BufferQueueCommand<T> = sealed class(BufferCommand)
    public q: CommandQueue<T>;
    
    public constructor(q: CommandQueue<T>) :=
    self.q := q;
    
    protected function Invoke(k: Buffer; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      yield sequence q.Invoke(c,cq,prev_ev);
      self.ev := q.ev;
    end;
    
    protected procedure UnInvoke; override;
    begin
      q.UnInvoke;
    end;
    
  end;
  
function BufferCommandQueue.AddQueue<T>(q: CommandQueue<T>) :=
AddCommand(new BufferQueueCommand<T>(q));

{$endregion AddQueue}

{$region WriteData}

type
  BufferCommandWriteData = sealed class(BufferCommand)
    public ptr: CommandQueue<IntPtr>;
    public offset, len: CommandQueue<integer>;
    
    public constructor(ptr: CommandQueue<IntPtr>; offset, len: CommandQueue<integer>);
    begin
      self.ptr := ptr;
      self.offset := offset;
      self.len := len;
    end;
    
    protected function Invoke(b: Buffer; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      
      var ev_lst := new List<cl_event>;
      yield sequence ptr   .Invoke(c, cq, cl_event.Zero); if ptr   .ev<>cl_event.Zero then ev_lst += ptr.ev;
      yield sequence offset.Invoke(c, cq, cl_event.Zero); if offset.ev<>cl_event.Zero then ev_lst += offset.ev;
      yield sequence len   .Invoke(c, cq, cl_event.Zero); if len   .ev<>cl_event.Zero then ev_lst += len.ev;
      
      if b.memobj=cl_mem.Zero then b.Init(c);
      
      ClearEvent;
      self.ev := cl.CreateUserEvent(c._context, ec);
      ec.RaiseIfError;
      
      yield Task.Run(()->
      begin
        if ev_lst.Count<>0 then cl.WaitForEvents(ev_lst.Count, ev_lst.ToArray).RaiseIfError;
        
        var buff_ev: cl_event;
        if prev_ev=cl_event.Zero then
          cl.EnqueueWriteBuffer(cq, b.memobj, 0, new UIntPtr(offset.res), new UIntPtr(len.res), ptr.res, 0,nil,@buff_ev).RaiseIfError else
          cl.EnqueueWriteBuffer(cq, b.memobj, 0, new UIntPtr(offset.res), new UIntPtr(len.res), ptr.res, 1,@prev_ev,@buff_ev).RaiseIfError;
        cl.WaitForEvents(1, @buff_ev).RaiseIfError;
        
        cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
      end);
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      ptr.UnInvoke;
      offset.UnInvoke;
      len.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  BufferCommandWriteArray = sealed class(BufferCommand)
    public a: CommandQueue<&Array>;
    public offset, len: CommandQueue<integer>;
    
    public constructor(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>);
    begin
      self.a := a;
      self.offset := offset;
      self.len := len;
    end;
    
    protected function Invoke(b: Buffer; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ev_lst := new List<cl_event>;
      var ec: ErrorCode;
      
      yield sequence a     .Invoke(c, cq, cl_event.Zero);
      yield sequence offset.Invoke(c, cq, cl_event.Zero); if offset.ev<>cl_event.Zero then ev_lst += offset.ev;
      yield sequence len   .Invoke(c, cq, cl_event.Zero); if len   .ev<>cl_event.Zero then ev_lst += len.ev;
      
      if b.memobj=cl_mem.Zero then b.Init(c);
      
      ClearEvent;
      self.ev := cl.CreateUserEvent(c._context, ec);
      ec.RaiseIfError;
      
      yield Task.Run(()->
      begin
        if a.ev<>cl_event.Zero then cl.WaitForEvents(1,@a.ev).RaiseIfError;
        var gchnd := GCHandle.Alloc(a.res, GCHandleType.Pinned);
        
        if ev_lst.Count<>0 then cl.WaitForEvents(ev_lst.Count, ev_lst.ToArray).RaiseIfError;
        
        var buff_ev: cl_event;
        if prev_ev=cl_event.Zero then
          cl.EnqueueWriteBuffer(cq, b.memobj, 0, new UIntPtr(offset.res), new UIntPtr(len.res), gchnd.AddrOfPinnedObject, 0,nil,@buff_ev).RaiseIfError else
          cl.EnqueueWriteBuffer(cq, b.memobj, 0, new UIntPtr(offset.res), new UIntPtr(len.res), gchnd.AddrOfPinnedObject, 1,@prev_ev,@buff_ev).RaiseIfError;
        cl.WaitForEvents(1,@buff_ev).RaiseIfError;
        
        cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
        gchnd.Free;
      end);
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      a.UnInvoke;
      offset.UnInvoke;
      len.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  BufferCommandWriteValue = sealed class(BufferCommand)
    public ptr: CommandQueue<IntPtr>;
    public offset, len: CommandQueue<integer>;
    
    public constructor(ptr: CommandQueue<IntPtr>; offset, len: CommandQueue<integer>);
    begin
      self.ptr := ptr;
      self.offset := offset;
      self.len := len;
    end;
    
    protected function Invoke(b: Buffer; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      
      var ev_lst := new List<cl_event>;
      yield sequence ptr   .Invoke(c, cq, cl_event.Zero); if ptr   .ev<>cl_event.Zero then ev_lst += ptr.ev;
      yield sequence offset.Invoke(c, cq, cl_event.Zero); if offset.ev<>cl_event.Zero then ev_lst += offset.ev;
      yield sequence len   .Invoke(c, cq, cl_event.Zero); if len   .ev<>cl_event.Zero then ev_lst += len.ev;
      
      if b.memobj=cl_mem.Zero then b.Init(c);
      
      ClearEvent;
      self.ev := cl.CreateUserEvent(c._context, ec);
      ec.RaiseIfError;
      
      yield Task.Run(()->
      begin
        if ev_lst.Count<>0 then cl.WaitForEvents(ev_lst.Count, ev_lst.ToArray).RaiseIfError;
        
        var buff_ev: cl_event;
        if prev_ev=cl_event.Zero then
          cl.EnqueueWriteBuffer(cq, b.memobj, 0, new UIntPtr(offset.res), new UIntPtr(len.res), ptr.res, 0,nil,@buff_ev).RaiseIfError else
          cl.EnqueueWriteBuffer(cq, b.memobj, 0, new UIntPtr(offset.res), new UIntPtr(len.res), ptr.res, 1,@prev_ev,@buff_ev).RaiseIfError;
        cl.WaitForEvents(1, @buff_ev).RaiseIfError;
        
        cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
        Marshal.FreeHGlobal(ptr.res);
      end);
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      ptr.UnInvoke;
      offset.UnInvoke;
      len.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  
  
function BufferCommandQueue.AddWriteData(ptr: CommandQueue<IntPtr>; offset, len: CommandQueue<integer>) :=
AddCommand(new BufferCommandWriteData(ptr, offset, len));
function BufferCommandQueue.AddWriteData(ptr: CommandQueue<IntPtr>) := AddWriteData(ptr, 0,integer(res.sz.ToUInt32));

function BufferCommandQueue.AddWriteArray(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>) :=
AddCommand(new BufferCommandWriteArray(a, offset, len));
function BufferCommandQueue.AddWriteArray(a: CommandQueue<&Array>) := AddWriteArray(a, 0,integer(res.sz.ToUInt32));


function BufferCommandQueue.AddWriteValue<TRecord>(val: TRecord; offset: CommandQueue<integer>): BufferCommandQueue;
begin
  var sz := Marshal.SizeOf&<TRecord>;
  var ptr := Marshal.AllocHGlobal(sz);
  var typed_ptr: ^TRecord := pointer(ptr);
  typed_ptr^ := val;
  Result := AddCommand(new BufferCommandWriteValue(ptr, offset,Marshal.SizeOf&<TRecord>));
end;

function BufferCommandQueue.AddWriteValue<TRecord>(val: CommandQueue<TRecord>; offset: CommandQueue<integer>) :=
AddCommand(new BufferCommandWriteValue(
  val.ThenConvert&<IntPtr>(vval-> //ToDo #2067
  begin
    var sz := Marshal.SizeOf&<TRecord>;
    var ptr := Marshal.AllocHGlobal(sz);
    var typed_ptr: ^TRecord := pointer(ptr);
    typed_ptr^ := TRecord(object(vval)); //ToDo #2068
    Result := ptr;
  end),
  offset,
  Marshal.SizeOf&<TRecord>
));

{$endregion WriteData}

{$region ReadData}

type
  BufferCommandReadData = sealed class(BufferCommand)
    public ptr: CommandQueue<IntPtr>;
    public offset, len: CommandQueue<integer>;
    
    public constructor(ptr: CommandQueue<IntPtr>; offset, len: CommandQueue<integer>);
    begin
      self.ptr := ptr;
      self.offset := offset;
      self.len := len;
    end;
    
    protected function Invoke(b: Buffer; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      
      var ev_lst := new List<cl_event>;
      yield sequence ptr   .Invoke(c, cq, cl_event.Zero); if ptr   .ev<>cl_event.Zero then ev_lst += ptr.ev;
      yield sequence offset.Invoke(c, cq, cl_event.Zero); if offset.ev<>cl_event.Zero then ev_lst += offset.ev;
      yield sequence len   .Invoke(c, cq, cl_event.Zero); if len   .ev<>cl_event.Zero then ev_lst += len.ev;
      
      if b.memobj=cl_mem.Zero then b.Init(c);
      
      ClearEvent;
      self.ev := cl.CreateUserEvent(c._context, ec);
      ec.RaiseIfError;
      
      yield Task.Run(()->
      begin
        if ev_lst.Count<>0 then cl.WaitForEvents(ev_lst.Count, ev_lst.ToArray).RaiseIfError;
        
        var buff_ev: cl_event;
        if prev_ev=cl_event.Zero then
          cl.EnqueueReadBuffer(cq, b.memobj, 0, new UIntPtr(offset.res), new UIntPtr(len.res), ptr.res, 0,nil,@buff_ev).RaiseIfError else
          cl.EnqueueReadBuffer(cq, b.memobj, 0, new UIntPtr(offset.res), new UIntPtr(len.res), ptr.res, 1,@prev_ev,@buff_ev).RaiseIfError;
        cl.WaitForEvents(1, @buff_ev).RaiseIfError;
        
        cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
      end);
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      ptr.UnInvoke;
      offset.UnInvoke;
      len.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  BufferCommandReadArray = sealed class(BufferCommand)
    public a: CommandQueue<&Array>;
    public offset, len: CommandQueue<integer>;
    
    public constructor(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>);
    begin
      self.a := a;
      self.offset := offset;
      self.len := len;
    end;
    
    protected function Invoke(b: Buffer; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ev_lst := new List<cl_event>;
      var ec: ErrorCode;
      
      yield sequence a     .Invoke(c, cq, cl_event.Zero);
      yield sequence offset.Invoke(c, cq, cl_event.Zero); if offset.ev<>cl_event.Zero then ev_lst += offset.ev;
      yield sequence len   .Invoke(c, cq, cl_event.Zero); if len   .ev<>cl_event.Zero then ev_lst += len.ev;
      
      if b.memobj=cl_mem.Zero then b.Init(c);
      
      ClearEvent;
      self.ev := cl.CreateUserEvent(c._context, ec);
      ec.RaiseIfError;
      
      yield Task.Run(()->
      begin
        if a.ev<>cl_event.Zero then cl.WaitForEvents(1,@a.ev).RaiseIfError;
        var gchnd := GCHandle.Alloc(a.res, GCHandleType.Pinned);
        
        if ev_lst.Count<>0 then cl.WaitForEvents(ev_lst.Count, ev_lst.ToArray).RaiseIfError;
        
        var buff_ev: cl_event;
        if prev_ev=cl_event.Zero then
          cl.EnqueueReadBuffer(cq, b.memobj, 0, new UIntPtr(offset.res), new UIntPtr(len.res), gchnd.AddrOfPinnedObject, 0,nil,@buff_ev).RaiseIfError else
          cl.EnqueueReadBuffer(cq, b.memobj, 0, new UIntPtr(offset.res), new UIntPtr(len.res), gchnd.AddrOfPinnedObject, 1,@prev_ev,@buff_ev).RaiseIfError;
        cl.WaitForEvents(1,@buff_ev).RaiseIfError;
        
        cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
        gchnd.Free;
      end);
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      a.UnInvoke;
      offset.UnInvoke;
      len.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  
  
function BufferCommandQueue.AddReadData(ptr: CommandQueue<IntPtr>; offset, len: CommandQueue<integer>) :=
AddCommand(new BufferCommandReadData(ptr, offset, len));
function BufferCommandQueue.AddReadData(ptr: CommandQueue<IntPtr>) := AddReadData(ptr, 0,integer(res.sz.ToUInt32));

function BufferCommandQueue.AddReadArray(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>) :=
AddCommand(new BufferCommandReadArray(a, offset, len));
function BufferCommandQueue.AddReadArray(a: CommandQueue<&Array>) := AddReadArray(a, 0,integer(res.sz.ToUInt32));

{$endregion ReadData}

{$region PatternFill}

type
  BufferCommandDataFill = sealed class(BufferCommand)
    public ptr: CommandQueue<IntPtr>;
    public pattern_len, offset, len: CommandQueue<integer>;
    
    public constructor(ptr: CommandQueue<IntPtr>; pattern_len, offset, len: CommandQueue<integer>);
    begin
      self.ptr := ptr;
      self.pattern_len := pattern_len;
      self.offset := offset;
      self.len := len;
    end;
    
    protected function Invoke(b: Buffer; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      
      var ev_lst := new List<cl_event>;
      yield sequence ptr         .Invoke(c, cq, cl_event.Zero); if ptr         .ev<>cl_event.Zero then ev_lst += ptr.ev;
      yield sequence pattern_len .Invoke(c, cq, cl_event.Zero); if pattern_len .ev<>cl_event.Zero then ev_lst += pattern_len.ev;
      yield sequence offset      .Invoke(c, cq, cl_event.Zero); if offset      .ev<>cl_event.Zero then ev_lst += offset.ev;
      yield sequence len         .Invoke(c, cq, cl_event.Zero); if len         .ev<>cl_event.Zero then ev_lst += len.ev;
      
      if b.memobj=cl_mem.Zero then b.Init(c);
      
      ClearEvent;
      self.ev := cl.CreateUserEvent(c._context, ec);
      ec.RaiseIfError;
      
      yield Task.Run(()->
      begin
        if ev_lst.Count<>0 then cl.WaitForEvents(ev_lst.Count, ev_lst.ToArray).RaiseIfError;
        
        var buff_ev: cl_event;
        if prev_ev=cl_event.Zero then
          cl.EnqueueFillBuffer(cq, b.memobj, ptr.res,new UIntPtr(pattern_len.res), new UIntPtr(offset.res),new UIntPtr(len.res), 0,nil,@buff_ev).RaiseIfError else
          cl.EnqueueFillBuffer(cq, b.memobj, ptr.res,new UIntPtr(pattern_len.res), new UIntPtr(offset.res),new UIntPtr(len.res), 1,@prev_ev,@buff_ev).RaiseIfError;
        cl.WaitForEvents(1, @buff_ev).RaiseIfError;
        
        cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
      end);
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      ptr.UnInvoke;
      pattern_len.UnInvoke;
      offset.UnInvoke;
      len.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  BufferCommandArrayFill = sealed class(BufferCommand)
    public a: CommandQueue<&Array>;
    public offset, len: CommandQueue<integer>;
    
    public constructor(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>);
    begin
      self.a := a;
      self.offset := offset;
      self.len := len;
    end;
    
    protected function Invoke(b: Buffer; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ev_lst := new List<cl_event>;
      var ec: ErrorCode;
      
      yield sequence a     .Invoke(c, cq, cl_event.Zero);
      yield sequence offset.Invoke(c, cq, cl_event.Zero); if offset.ev<>cl_event.Zero then ev_lst += offset.ev;
      yield sequence len   .Invoke(c, cq, cl_event.Zero); if len   .ev<>cl_event.Zero then ev_lst += len.ev;
      
      if b.memobj=cl_mem.Zero then b.Init(c);
      
      ClearEvent;
      self.ev := cl.CreateUserEvent(c._context, ec);
      ec.RaiseIfError;
      
      yield Task.Run(()->
      begin
        if a.ev<>cl_event.Zero then cl.WaitForEvents(1,@a.ev).RaiseIfError;
        var gchnd := GCHandle.Alloc(a.res, GCHandleType.Pinned);
        var pattern_sz := Marshal.SizeOf(a.res.GetType.GetElementType) * a.res.Length;
        
        if ev_lst.Count<>0 then cl.WaitForEvents(ev_lst.Count, ev_lst.ToArray).RaiseIfError;
        
        var buff_ev: cl_event;
        if prev_ev=cl_event.Zero then
          cl.EnqueueFillBuffer(cq, b.memobj, gchnd.AddrOfPinnedObject,new UIntPtr(pattern_sz), new UIntPtr(offset.res),new UIntPtr(len.res), 0,nil,@buff_ev).RaiseIfError else
          cl.EnqueueFillBuffer(cq, b.memobj, gchnd.AddrOfPinnedObject,new UIntPtr(pattern_sz), new UIntPtr(offset.res),new UIntPtr(len.res), 1,@prev_ev,@buff_ev).RaiseIfError;
        cl.WaitForEvents(1,@buff_ev).RaiseIfError;
        
        cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
        gchnd.Free;
      end);
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      a.UnInvoke;
      offset.UnInvoke;
      len.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  BufferCommandValueFill = sealed class(BufferCommand)
    public ptr: CommandQueue<IntPtr>;
    public pattern_len, offset, len: CommandQueue<integer>;
    
    public constructor(ptr: CommandQueue<IntPtr>; pattern_len, offset, len: CommandQueue<integer>);
    begin
      self.ptr := ptr;
      self.pattern_len := pattern_len;
      self.offset := offset;
      self.len := len;
    end;
    
    protected function Invoke(b: Buffer; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      
      var ev_lst := new List<cl_event>;
      yield sequence ptr         .Invoke(c, cq, cl_event.Zero); if ptr         .ev<>cl_event.Zero then ev_lst += ptr.ev;
      yield sequence pattern_len .Invoke(c, cq, cl_event.Zero); if pattern_len .ev<>cl_event.Zero then ev_lst += pattern_len.ev;
      yield sequence offset      .Invoke(c, cq, cl_event.Zero); if offset      .ev<>cl_event.Zero then ev_lst += offset.ev;
      yield sequence len         .Invoke(c, cq, cl_event.Zero); if len         .ev<>cl_event.Zero then ev_lst += len.ev;
      
      if b.memobj=cl_mem.Zero then b.Init(c);
      
      ClearEvent;
      self.ev := cl.CreateUserEvent(c._context, ec);
      ec.RaiseIfError;
      
      yield Task.Run(()->
      begin
        if ev_lst.Count<>0 then cl.WaitForEvents(ev_lst.Count, ev_lst.ToArray).RaiseIfError;
        
        var buff_ev: cl_event;
        if prev_ev=cl_event.Zero then
          cl.EnqueueFillBuffer(cq, b.memobj, ptr.res,new UIntPtr(pattern_len.res), new UIntPtr(offset.res),new UIntPtr(len.res), 0,nil,@buff_ev).RaiseIfError else
          cl.EnqueueFillBuffer(cq, b.memobj, ptr.res,new UIntPtr(pattern_len.res), new UIntPtr(offset.res),new UIntPtr(len.res), 1,@prev_ev,@buff_ev).RaiseIfError;
        cl.WaitForEvents(1, @buff_ev).RaiseIfError;
        
        cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
        Marshal.FreeHGlobal(ptr.res);
      end);
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      ptr.UnInvoke;
      pattern_len.UnInvoke;
      offset.UnInvoke;
      len.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  
  
function BufferCommandQueue.AddFillData(ptr: CommandQueue<IntPtr>; pattern_len, offset, len: CommandQueue<integer>) :=
AddCommand(new BufferCommandDataFill(ptr,pattern_len, offset,len));
function BufferCommandQueue.AddFillData(ptr: CommandQueue<IntPtr>; pattern_len: CommandQueue<integer>) :=
AddFillData(ptr,pattern_len, 0,integer(res.sz.ToUInt32));

function BufferCommandQueue.AddFillArray(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>) :=
AddCommand(new BufferCommandArrayFill(a, offset,len));
function BufferCommandQueue.AddFillArray(a: CommandQueue<&Array>) :=
AddFillArray(a, 0,integer(res.sz.ToUInt32));


function BufferCommandQueue.AddFillValue<TRecord>(val: TRecord; offset, len: CommandQueue<integer>): BufferCommandQueue;
begin
  var sz := Marshal.SizeOf&<TRecord>;
  var ptr := Marshal.AllocHGlobal(sz);
  var typed_ptr: ^TRecord := pointer(ptr);
  typed_ptr^ := val;
  Result := AddCommand(new BufferCommandValueFill(ptr,Marshal.SizeOf&<TRecord>, offset,len));
end;

function BufferCommandQueue.AddFillValue<TRecord>(val: CommandQueue<TRecord>; offset, len: CommandQueue<integer>) :=
AddCommand(new BufferCommandValueFill(
  val.ThenConvert&<IntPtr>(vval-> //ToDo #2067
  begin
    var sz := Marshal.SizeOf&<TRecord>;
    var ptr := Marshal.AllocHGlobal(sz);
    var typed_ptr: ^TRecord := pointer(ptr);
    typed_ptr^ := TRecord(object(vval)); //ToDo #2068
    Result := ptr;
  end),
  Marshal.SizeOf&<TRecord>,
  offset, len
));

function BufferCommandQueue.AddFillValue<TRecord>(val: TRecord) :=
AddFillValue(val, 0,integer(res.sz.ToUInt32));

function BufferCommandQueue.AddFillValue<TRecord>(val: CommandQueue<TRecord>) :=
AddFillValue(val, 0,integer(res.sz.ToUInt32));

{$endregion PatternFill}

{$region Copy}

type
  BufferCommandCopy = sealed class(BufferCommand)
    public f_buf, t_buf: CommandQueue<Buffer>;
    public f_pos, t_pos, len: CommandQueue<integer>;
    
    public constructor(f_buf, t_buf: CommandQueue<Buffer>; f_pos, t_pos, len: CommandQueue<integer>);
    begin
      self.f_buf := f_buf;
      self.t_buf := t_buf;
      self.f_pos := f_pos;
      self.t_pos := t_pos;
      self.len := len;
    end;
    
    protected function Invoke(b: Buffer; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ec: ErrorCode;
      
      var buf_ev_lst := new List<cl_event>;
      yield sequence f_buf.Invoke(c, cq, cl_event.Zero); if f_buf.ev<>cl_event.Zero then buf_ev_lst += f_buf.ev;
      yield sequence t_buf.Invoke(c, cq, cl_event.Zero); if t_buf.ev<>cl_event.Zero then buf_ev_lst += t_buf.ev;
      
      var ev_lst := new List<cl_event>;
      yield sequence f_pos.Invoke(c, cq, cl_event.Zero); if f_pos.ev<>cl_event.Zero then ev_lst += f_pos.ev;
      yield sequence t_pos.Invoke(c, cq, cl_event.Zero); if t_pos.ev<>cl_event.Zero then ev_lst += t_pos.ev;
      yield sequence len  .Invoke(c, cq, cl_event.Zero); if len  .ev<>cl_event.Zero then ev_lst += len.ev;
      
      ClearEvent;
      self.ev := cl.CreateUserEvent(c._context, ec);
      ec.RaiseIfError;
      
      yield Task.Run(()->
      begin
        if buf_ev_lst.Count<>0 then cl.WaitForEvents(buf_ev_lst.Count, buf_ev_lst.ToArray).RaiseIfError;
        if f_buf.res.memobj=cl_mem.Zero then f_buf.res.Init(c);
        if t_buf.res.memobj=cl_mem.Zero then t_buf.res.Init(c);
        
        if ev_lst.Count<>0 then cl.WaitForEvents(ev_lst.Count, ev_lst.ToArray).RaiseIfError;
        
        var buff_ev: cl_event;
        if prev_ev=cl_event.Zero then
          cl.EnqueueCopyBuffer(cq, f_buf.res.memobj,t_buf.res.memobj, new UIntPtr(f_pos.res),new UIntPtr(t_pos.res), new UIntPtr(len.res), 0,nil,@buff_ev).RaiseIfError else
          cl.EnqueueCopyBuffer(cq, f_buf.res.memobj,t_buf.res.memobj, new UIntPtr(f_pos.res),new UIntPtr(t_pos.res), new UIntPtr(len.res), 1,@prev_ev,@buff_ev).RaiseIfError;
        cl.WaitForEvents(1, @buff_ev).RaiseIfError;
        
        cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
      end);
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      f_buf.UnInvoke; t_buf.UnInvoke;
      f_pos.UnInvoke; t_pos.UnInvoke;
      len.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;

function BufferCommandQueue.AddCopyFrom(b: CommandQueue<Buffer>; from, &to, len: CommandQueue<integer>) :=
AddCommand(new BufferCommandCopy(b,res, from,&to, len));
function BufferCommandQueue.AddCopyFrom(b: CommandQueue<Buffer>) := AddCopyFrom(b, 0,0, integer(res.sz.ToUInt32));

function BufferCommandQueue.AddCopyTo(b: CommandQueue<Buffer>; from, &to, len: CommandQueue<integer>) :=
AddCommand(new BufferCommandCopy(res,b, &to,from, len));
function BufferCommandQueue.AddCopyTo(b: CommandQueue<Buffer>) := AddCopyTo(b, 0,0, integer(res.sz.ToUInt32));

{$endregion Copy}

{$endregion Buffer}

{$region Kernel}

{$region AddQueue}

type
  KernelQueueCommand<T> = sealed class(KernelCommand)
    public q: CommandQueue<T>;
    
    public constructor(q: CommandQueue<T>) :=
    self.q := q;
    
    protected function Invoke(k: Kernel; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      yield sequence q.Invoke(c,cq,prev_ev);
      self.ev := q.ev;
    end;
    
    protected procedure UnInvoke; override;
    begin
      q.UnInvoke;
    end;
    
  end;
  
function KernelCommandQueue.AddQueue<T>(q: CommandQueue<T>) :=
AddCommand(new KernelQueueCommand<T>(q));

{$endregion AddQueue}

{$region Exec}

type
  KernelCommandExec = sealed class(KernelCommand)
    public work_szs: array of UIntPtr;
    public args_q: array of CommandQueue<Buffer>;
    
    public constructor(work_szs: array of UIntPtr; args: array of CommandQueue<Buffer>);
    begin
      self.work_szs := work_szs;
      self.args_q := args;
    end;
    
    protected function Invoke(k: Kernel; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ev_lst := new List<cl_event>;
      var ec: ErrorCode;
      
      foreach var arg_q in args_q do
      begin
        yield sequence arg_q.Invoke(c, cq, cl_event.Zero);
        if arg_q.ev<>cl_event.Zero then
          ev_lst += arg_q.ev;
      end;
      
      ClearEvent;
      self.ev := cl.CreateUserEvent(c._context, ec);
      ec.RaiseIfError;
      
      yield Task.Run(()->
      begin
        if ev_lst.Count<>0 then cl.WaitForEvents(ev_lst.Count,ev_lst.ToArray);
        
        for var i := 0 to args_q.Length-1 do
        begin
          if args_q[i].res.memobj=cl_mem.Zero then args_q[i].res.Init(c);
          cl.SetKernelArg(k._kernel, i, new UIntPtr(UIntPtr.Size), args_q[i].res.memobj).RaiseIfError;
        end;
        
        var kernel_ev: cl_event;
        cl.EnqueueNDRangeKernel(cq, k._kernel, work_szs.Length, nil,work_szs,nil, 0,nil,@kernel_ev).RaiseIfError; // prev.ev уже в ev_lst, тут проверять не надо
        cl.WaitForEvents(1,@kernel_ev).RaiseIfError;
        
        cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
      end);
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      foreach var q in args_q do q.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  KernelQCommandExec = sealed class(KernelCommand)
    public work_szs_q: CommandQueue<array of UIntPtr>;
    public args_q: array of CommandQueue<Buffer>;
    
    public constructor(work_szs_q: CommandQueue<array of UIntPtr>; args: array of CommandQueue<Buffer>);
    begin
      self.work_szs_q := work_szs_q;
      self.args_q := args;
    end;
    
    protected function Invoke(k: Kernel; c: Context; cq: cl_command_queue; prev_ev: cl_event): sequence of Task; override;
    begin
      var ev_lst := new List<cl_event>;
      var ec: ErrorCode;
      
      yield sequence work_szs_q.Invoke(c,cq,cl_event.Zero);
      
      foreach var arg_q in args_q do
      begin
        yield sequence arg_q.Invoke(c, cq, cl_event.Zero);
        if arg_q.ev<>cl_event.Zero then
          ev_lst += arg_q.ev;
      end;
      
      ClearEvent;
      self.ev := cl.CreateUserEvent(c._context, ec);
      ec.RaiseIfError;
      
      yield Task.Run(()->
      begin
        if work_szs_q.ev<>cl_event.Zero then cl.WaitForEvents(1,@work_szs_q.ev);
        var work_szs := work_szs_q.res;
        
        if ev_lst.Count<>0 then cl.WaitForEvents(ev_lst.Count,ev_lst.ToArray);
        
        for var i := 0 to args_q.Length-1 do
        begin
          if args_q[i].res.memobj=cl_mem.Zero then args_q[i].res.Init(c);
          cl.SetKernelArg(k._kernel, i, new UIntPtr(UIntPtr.Size), args_q[i].res.memobj).RaiseIfError;
        end;
        
        var kernel_ev: cl_event;
        cl.EnqueueNDRangeKernel(cq, k._kernel, work_szs.Length, nil,work_szs,nil, 0,nil,@kernel_ev).RaiseIfError; // prev.ev уже в ev_lst, тут проверять не надо
        cl.WaitForEvents(1,@kernel_ev).RaiseIfError;
        
        cl.SetUserEventStatus(self.ev, CommandExecutionStatus.COMPLETE).RaiseIfError;
      end);
      
    end;
    
    protected procedure UnInvoke; override;
    begin
      foreach var q in args_q do q.UnInvoke;
    end;
    
    public procedure Finalize; override :=
    ClearEvent;
    
  end;
  
function KernelCommandQueue.AddExec(work_szs: array of UIntPtr; params args: array of CommandQueue<Buffer>) :=
AddCommand(new KernelCommandExec(work_szs, args));

function KernelCommandQueue.AddExec(work_szs: array of CommandQueue<UIntPtr>; params args: array of CommandQueue<Buffer>) :=
AddCommand(new KernelQCommandExec(
  CombineAsyncQueue(a->a,work_szs),
  args
));

function KernelCommandQueue.AddExec(work_szs: CommandQueue<array of UIntPtr>; params args: array of CommandQueue<Buffer>) :=
AddCommand(new KernelQCommandExec(
  work_szs,
  args
));

function KernelCommandQueue.AddExec(work_szs: CommandQueue<array of integer>; params args: array of CommandQueue<Buffer>) :=
AddCommand(new KernelQCommandExec(
  work_szs.ThenConvert(a->a.ConvertAll(sz->new UIntPtr(sz))),
  args
));

{$endregion Exec}

{$endregion Kernel}

{$endregion CommandQueue}

{$region Buffer}

{$region constructor's}

procedure Buffer.Init(c: Context);
begin
  var ec: ErrorCode;
  if self.memobj<>cl_mem.Zero then cl.ReleaseMemObject(self.memobj);
  self.memobj := cl.CreateBuffer(c._context, MemoryFlags.READ_WRITE, self.sz, IntPtr.Zero, ec);
  ec.RaiseIfError;
end;

function Buffer.SubBuff(offset, size: integer): Buffer;
begin
  if self.memobj=cl_mem.Zero then Init(Context.Default);
  
  Result := new Buffer(size);
  Result._parent := self;
  
  var ec: ErrorCode;
  var reg := new cl_buffer_region(
    new UIntPtr( offset ),
    new UIntPtr( size )
  );
  Result.memobj := cl.CreateSubBuffer(self.memobj, MemoryFlags.READ_WRITE, BufferCreateType.REGION, pointer(@reg), ec);
  ec.RaiseIfError;
  
end;

{$endregion constructor's}

{$region Write}

function Buffer.WriteData(ptr: CommandQueue<IntPtr>) :=
Context.Default.SyncInvoke(NewQueue.AddWriteData(ptr) as CommandQueue<Buffer>);
function Buffer.WriteData(ptr: CommandQueue<IntPtr>; offset, len: CommandQueue<integer>) :=
Context.Default.SyncInvoke(NewQueue.AddWriteData(ptr, offset, len) as CommandQueue<Buffer>);

function Buffer.WriteArray(a: CommandQueue<&Array>) :=
Context.Default.SyncInvoke(NewQueue.AddWriteArray(a) as CommandQueue<Buffer>);
function Buffer.WriteArray(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>) :=
Context.Default.SyncInvoke(NewQueue.AddWriteArray(a, offset, len) as CommandQueue<Buffer>);

function Buffer.WriteValue<TRecord>(val: CommandQueue<TRecord>; offset: CommandQueue<integer>) :=
Context.Default.SyncInvoke(NewQueue.AddWriteValue(val, offset) as CommandQueue<Buffer>);

{$endregion Write}

{$region Read}

function Buffer.ReadData(ptr: CommandQueue<IntPtr>) :=
Context.Default.SyncInvoke(NewQueue.AddReadData(ptr) as CommandQueue<Buffer>);
function Buffer.ReadData(ptr: CommandQueue<IntPtr>; offset, len: CommandQueue<integer>) :=
Context.Default.SyncInvoke(NewQueue.AddReadData(ptr, offset, len) as CommandQueue<Buffer>);

function Buffer.ReadArray(a: CommandQueue<&Array>) :=
Context.Default.SyncInvoke(NewQueue.AddReadArray(a) as CommandQueue<Buffer>);
function Buffer.ReadArray(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>) :=
Context.Default.SyncInvoke(NewQueue.AddReadArray(a, offset, len) as CommandQueue<Buffer>);

{$endregion Read}

{$region PatternFill}

function Buffer.FillData(ptr: CommandQueue<IntPtr>; pattern_len: CommandQueue<integer>) :=
Context.Default.SyncInvoke(NewQueue.AddFillData(ptr, pattern_len) as CommandQueue<Buffer>);
function Buffer.FillData(ptr: CommandQueue<IntPtr>; pattern_len, offset, len: CommandQueue<integer>) :=
Context.Default.SyncInvoke(NewQueue.AddFillData(ptr, pattern_len, offset, len) as CommandQueue<Buffer>);

function Buffer.FillArray(a: CommandQueue<&Array>) :=
Context.Default.SyncInvoke(NewQueue.AddFillArray(a) as CommandQueue<Buffer>);
function Buffer.FillArray(a: CommandQueue<&Array>; offset, len: CommandQueue<integer>) :=
Context.Default.SyncInvoke(NewQueue.AddFillArray(a, offset, len) as CommandQueue<Buffer>);

function Buffer.FillValue<TRecord>(val: TRecord) :=
Context.Default.SyncInvoke(NewQueue.AddFillValue(val) as CommandQueue<Buffer>);
function Buffer.FillValue<TRecord>(val: TRecord; offset, len: CommandQueue<integer>) :=
Context.Default.SyncInvoke(NewQueue.AddFillValue(val, offset, len) as CommandQueue<Buffer>);
function Buffer.FillValue<TRecord>(val: CommandQueue<TRecord>) :=
Context.Default.SyncInvoke(NewQueue.AddFillValue(val) as CommandQueue<Buffer>);
function Buffer.FillValue<TRecord>(val: CommandQueue<TRecord>; offset, len: CommandQueue<integer>) :=
Context.Default.SyncInvoke(NewQueue.AddFillValue(val, offset, len) as CommandQueue<Buffer>);

{$endregion PatternFill}

{$region Copy}

function Buffer.CopyFrom(b: CommandQueue<Buffer>; from, &to, len: CommandQueue<integer>) :=
Context.Default.SyncInvoke(NewQueue.AddCopyFrom(b, from, &to, len) as CommandQueue<Buffer>);
function Buffer.CopyFrom(b: CommandQueue<Buffer>) :=
Context.Default.SyncInvoke(NewQueue.AddCopyFrom(b) as CommandQueue<Buffer>);

function Buffer.CopyTo(b: CommandQueue<Buffer>; from, &to, len: CommandQueue<integer>) :=
Context.Default.SyncInvoke(NewQueue.AddCopyTo(b, from, &to, len) as CommandQueue<Buffer>);
function Buffer.CopyTo(b: CommandQueue<Buffer>) :=
Context.Default.SyncInvoke(NewQueue.AddCopyTo(b) as CommandQueue<Buffer>);

{$endregion Copy}

{$region Get}

function Buffer.GetData(offset, len: CommandQueue<integer>): IntPtr;
begin
  var res: IntPtr;
  
  var Qs_len := len.Multiusable(2);
  
  var Q_res := Qs_len[0].ThenConvert(len_val->
  begin
    Result := Marshal.AllocHGlobal(len_val);
    res := Result;
  end);
  
  Context.Default.SyncInvoke(
    self.NewQueue.AddReadData(Q_res, offset,Qs_len[1]) as CommandQueue<Buffer>
  );
  
  Result := res;
end;

function Buffer.GetArrayAt<TArray>(offset: CommandQueue<integer>; szs: CommandQueue<array of integer>): TArray;
begin
  var el_t := typeof(TArray).GetElementType;
  var res: &Array;
  
  var Qs_szs := szs.Multiusable(2);
  
  var Q_res := Qs_szs[0].ThenConvert(szs_val->
  begin
    Result := System.Array.CreateInstance(
      el_t,
      szs_val
    );
    res := Result;
  end);
  var Q_res_len := Qs_szs[1].ThenConvert( szs_val -> Marshal.SizeOf(el_t)*szs_val.Aggregate((i1,i2)->i1*i2) );
  
  Context.Default.SyncInvoke(
    self.NewQueue
    .AddReadArray(Q_res, offset, Q_res_len) as CommandQueue<Buffer>
  );
  
  Result := TArray(res);
end;

function Buffer.GetArrayAt<TArray>(offset: CommandQueue<integer>; params szs: array of CommandQueue<integer>) :=
GetArrayAt&<TArray>(offset, CombineAsyncQueue(a->a, szs));

function Buffer.GetValueAt<TRecord>(offset: CommandQueue<integer>): TRecord;
begin
  Context.Default.SyncInvoke(
    self.NewQueue
    .AddReadValue(Result, offset) as CommandQueue<Buffer>
  );
end;

{$endregion Get}

{$endregion Buffer}

{$region Kernel}

{$region constructor's}

constructor Kernel.Create(prog: ProgramCode; name: string);
begin
  var ec: ErrorCode;
  
  self._kernel := cl.CreateKernel(prog._program, name, ec);
  ec.RaiseIfError;
  
end;

{$endregion constructor's}

{$region Exec}

function Kernel.Exec(work_szs: array of UIntPtr; params args: array of CommandQueue<Buffer>) :=
Context.Default.SyncInvoke(NewQueue.AddExec(work_szs, args) as CommandQueue<Kernel>);
function Kernel.Exec(work_szs: array of CommandQueue<UIntPtr>; params args: array of CommandQueue<Buffer>) :=
Context.Default.SyncInvoke(NewQueue.AddExec(work_szs, args) as CommandQueue<Kernel>);
function Kernel.Exec(work_szs: CommandQueue<array of UIntPtr>; params args: array of CommandQueue<Buffer>) :=
Context.Default.SyncInvoke(NewQueue.AddExec(work_szs, args) as CommandQueue<Kernel>);
function Kernel.Exec(work_szs: CommandQueue<array of integer>; params args: array of CommandQueue<Buffer>) :=
Context.Default.SyncInvoke(NewQueue.AddExec(work_szs, args) as CommandQueue<Kernel>);

{$endregion Exec}

{$endregion Kernel}

{$region Сахарные подпрограммы}

function HFQ<T>(f: ()->T) :=
new CommandQueueHostFunc<T>(f);

function HPQ(p: ()->()) :=
HFQ&<object>(
  ()->
  begin
    p();
    Result := nil;
  end
);

function CombineSyncQueue<T>(qs: List<CommandQueueBase>) :=
new CommandQueueSyncList<T>(qs);
function CombineSyncQueue<T>(qs: List<CommandQueue<T>>) :=
new CommandQueueTSyncList<T>(qs);
function CombineSyncQueue<T>(params qs: array of CommandQueueBase) :=
new CommandQueueSyncList<T>(qs);
function CombineSyncQueue<T>(params qs: array of CommandQueue<T>) :=
new CommandQueueTSyncList<T>(qs);

function CombineSyncQueue<T, TRes>(conv: Func<array of object, TRes>; qs: List<CommandQueueBase>) :=
new CommandQueueCSyncList<TRes>(qs, conv);
function CombineSyncQueue<T, TRes>(conv: Func<array of T, TRes>; qs: List<CommandQueue<T>>) :=
new CommandQueueCTSyncList<T, TRes>(qs, conv);
function CombineSyncQueue<T, TRes>(conv: Func<array of object, TRes>; params qs: array of CommandQueueBase) :=
new CommandQueueCSyncList<TRes>(qs, conv);
function CombineSyncQueue<T, TRes>(conv: Func<array of T, TRes>; params qs: array of CommandQueue<T>) :=
new CommandQueueCTSyncList<T, TRes>(qs, conv);

function CombineAsyncQueue<T>(qs: List<CommandQueueBase>): CommandQueue<T> :=
new CommandQueueSyncList<T>(qs);
function CombineAsyncQueue<T>(qs: List<CommandQueue<T>>): CommandQueue<T> :=
new CommandQueueTSyncList<T>(qs);
function CombineAsyncQueue<T>(params qs: array of CommandQueueBase): CommandQueue<T> :=
new CommandQueueSyncList<T>(qs);
function CombineAsyncQueue<T>(params qs: array of CommandQueue<T>) :=
new CommandQueueTAsyncList<T>(qs);

function CombineAsyncQueue<T, TRes>(conv: Func<array of object, TRes>; qs: List<CommandQueueBase>) :=
new CommandQueueCAsyncList<TRes>(qs, conv);
function CombineAsyncQueue<T, TRes>(conv: Func<array of T, TRes>; qs: List<CommandQueue<T>>) :=
new CommandQueueCTAsyncList<T, TRes>(qs, conv);
function CombineAsyncQueue<T, TRes>(conv: Func<array of object, TRes>; params qs: array of CommandQueueBase) :=
new CommandQueueCAsyncList<TRes>(qs, conv);
function CombineAsyncQueue<T, TRes>(conv: Func<array of T, TRes>; params qs: array of CommandQueue<T>) :=
new CommandQueueCTAsyncList<T, TRes>(qs, conv);

{$endregion Сахарные подпрограммы}

end.