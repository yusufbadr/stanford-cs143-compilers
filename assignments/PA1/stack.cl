class Stack {
   isNil() : Bool { true };
   head() : String { { abort(); "";}};
   tail() : Stack { { abort(); self; } };
   construct(s : String) : Stack {

      (new Cons).init(s, self)
      
   };

   push (s : String) : Stack { self };

   pop () : Stack { self };
};

class Cons inherits Stack {
   -- top elem and rest of stack
   top : String;
   rest : Stack;

   isNil() : Bool { false };
   head() : String { top };
   tail() : Stack { rest };

   init (s : String, tail : Stack) : Stack {
      {
         top <- s;
         rest <- tail;
         self;
      }
   };

   push (s : String) : Stack {
      {
         (new Cons).init(s, self);
      }
   };

   pop () : Stack { rest };
};

class StackManager inherits A2I {
   stack : Stack;

   --debug
   io : IO <- new IO;
   
   init() : StackManager {
      {
         stack <- new Stack;
         self;
      }
   };

   push (s : String) : Object {
      if (stack.isNil()) then
         stack <- (new Cons).init(s, new Stack)
      else
         stack <- stack.push(s)
      fi
   };

   top () : String {
      stack.head()
   };

   isEmpty () : Bool {
      stack.isNil()
   };

   pop () : Object {
      stack <- stack.pop()
   };

   evaluate () : Object {
      if (not isEmpty())  then 
      {
         let top : String <- top() in {
            pop();

            if (top="+") then
            {
               let first : String <- top() in {
                  pop();
                  let second : String <- top() in {
                     pop();
                     -- push sum of first and second
                     push(i2a(a2i(first) + a2i(second)));
                  };
               };
            } 
            else
            {
               if (top="s") then
               {
                  let first : String <- top() in {
                     pop();
                     let second : String <- top() in {
                        pop();
                        
                        -- push in reverse order (swap)
                        push(first);
                        push(second);
                     };
                  };
               }
               else
                  -- int at top of stack (no change to be made)
                  -- push what has been popped
                  push(top)
               fi;
            }
            fi;
  
         };

      } else
         -- no element at top of stack
         -- nothing to evaluate
         ""
      fi
   };

   getContentsHelper(stack : Stack) : String {
      if (stack.isNil()) then
         "" -- returns nothing since stack is now empty
      else
         stack.head().concat("\n").concat(getContentsHelper(stack.tail()))
      fi
   };

   getContents () : String {
      getContentsHelper(stack)
   };

};

class Main inherits IO{

   stackManager : StackManager;

   main () : Object {
      {
         stackManager <- (new StackManager).init();
         -- REMOVE IF TESTING WITH 'make test' for better readability
         out_string(">");
         let input : String <- in_string() in {
            while (not (input="x")) loop
               {
                  if (input = "+") then
                     -- push + to the top of the stack
                     stackManager.push(input)
                  else
                        if (input = "s") then
                           -- push s to the top of the stack
                           stackManager.push(input)
                        else
                           if (input = "e") then
                              -- evaluate top of stack
                              stackManager.evaluate()
                              
                           else
                              if (input = "d") then
                                 -- display stack contents
                                 -- debug
                                 out_string(stackManager.getContents())
                                 
                              else
                                 -- push int to stack
                                 stackManager.push(input)
                              fi
                           fi
                         
                        fi
                     
                  fi;
                  
                  -- REMOVE IF TESTING WITH 'make test' for better readability
                  out_string(">");
                  
                  input <- in_string();
                  
               }
            pool;
         };
      }
   };
};