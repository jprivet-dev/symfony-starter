<?php

namespace App\Form\Type;

use App\Form\DataTransformer\BcMathNumberToStringTransformer;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\FormInterface;
use Symfony\Component\Form\FormView;
use Symfony\Component\OptionsResolver\OptionsResolver;

class BcMathNumberType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder->addViewTransformer(new BcMathNumberToStringTransformer($options['scale']));
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'compound' => false,
            'scale' => null,
            'html5' => false,
            'invalid_message' => 'Please enter a number.',
        ]);

        $resolver->setAllowedTypes('scale', ['null', 'int']);
        $resolver->setAllowedTypes('html5', 'bool');
    }

    public function buildView(FormView $view, FormInterface $form, array $options): void
    {
        if ($options['html5']) {
            $view->vars['type'] = 'number';

            if (!isset($view->vars['attr']['step'])) {
                $view->vars['attr']['step'] = 'any';
            }
        } else {
            $view->vars['attr']['inputmode'] = 0 === $options['scale'] ? 'numeric' : 'decimal';
        }
    }

    public function getBlockPrefix(): string
    {
        return 'bcmath_number';
    }
}
